local Enemy = {}
Enemy.__index = Enemy

enemy_bullets = {}

function Enemy:new(x, y, patrolPoints)
    local enemy = {}
    setmetatable(enemy, Enemy)
    enemy.canMove = true
    --enemy.sprite = love.graphics.newImage("assets/sprites/enemy.png") 
    enemy.x = x
    enemy.y = y
    enemy.width = 48
    enemy.height = 64
    enemy.speed = 20000
    enemy.chaseSpeed = 30000 -- Szybkość podczas pościgu
    enemy.body = love.physics.newBody(world, enemy.x, enemy.y, "dynamic")
    local radius = math.max(enemy.width, enemy.height) / 2 * 0.8 -- promień nieco mniejszy niż przeciwnik
    enemy.shape = love.physics.newCircleShape(radius)
    enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape)
    enemy.body:setFixedRotation(true)
    
    enemy.hp = 50
    enemy.shoot_cooldown = 1.5  -- Czas między strzałami
    enemy.last_shot_time = 0
    enemy.angle = 0
    
    -- Parametry patrolowania
    enemy.patrolPoints = patrolPoints or {
        {x = x - 200, y = y},      -- Domyślny punkt 1 (lewo)
        {x = x, y = y - 200},      -- Domyślny punkt 2 (góra)
        {x = x + 200, y = y},      -- Domyślny punkt 3 (prawo)
        {x = x, y = y + 200},       -- Domyślny punkt 4 (dół)
        {x = x - 400, y = y + 200},       -- Powrót do punktu 1
        {x = x - 200, y = y - 200},       -- Powrót do punktu 2
        {x = x + 200, y = y - 200},       -- Powrót do punktu 3
    }
    enemy.currentPatrolPoint = 1
    enemy.patrolWaitTime = 2       -- Czas postoju w punkcie patrolowania
    enemy.currentWaitTime = 0
    
    -- Parametry pola widzenia
    enemy.visionRange = 300        -- Zasięg widzenia
    enemy.visionAngle = math.pi/3  -- Kąt widzenia (60 stopni)
    enemy.attackRange = 250        -- Zasięg ataku
    
    -- Stan przeciwnika
    enemy.mode = "patrol"          -- patrol, chase, attack
    enemy.targetLastSeen = {x = x, y = y}  -- Ostatnia znana pozycja gracza
    
    -- Parametry losowości
    enemy.randomMovementTimer = 0
    enemy.randomMovementInterval = 0.5
    enemy.randomMovementOffset = {x = 0, y = 0}
    
    -- Dodatkowe parametry dla  rotacji w punktach patrolowych
    enemy.isRotating = false        -- Czy przeciwnik aktualnie się obraca w miejscu
    enemy.rotationSpeed = 3         -- Prędkość obrotu (rad/s)
    enemy.targetRotation = 0        -- Docelowy kąt obrotu
    enemy.rotationDirection = 1     -- Kierunek obrotu (1 = zgodnie z ruchem wskazówek, -1 = przeciwnie)
    enemy.rotationAmount = 0        -- Ile już obróciliśmy się (w radianach)
    
    return enemy
end

function Enemy:draw()
    -- Rysuj przeciwnika
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.angle)
    love.graphics.rectangle("fill", -self.width/2, -self.height/2, self.width, self.height)
    
    -- Rysuj broń
    love.graphics.setColor(0.7, 0, 0)
    love.graphics.rectangle("fill", 
                        self.width/2, 
                        0 - 5, 
                        20, 
                        10)
    
    love.graphics.pop()
    
    -- Rysuj pole widzenia (w trybie debug)
    if DEBUG_MODE then
        love.graphics.setColor(1, 1, 0, 0.2)
        local segments = 20
        local points = {}
        for i = 0, segments do
            local angle = self.angle - self.visionAngle/2 + (self.visionAngle/segments) * i
            table.insert(points, self.x)
            table.insert(points, self.y)
            table.insert(points, self.x + math.cos(angle) * self.visionRange)
            table.insert(points, self.y + math.sin(angle) * self.visionRange)
        end
        love.graphics.setLineWidth(2)
        love.graphics.setColor(1, 0, 0, 0.3)
        for i = 1, #points - 3, 4 do
            love.graphics.line(points[i], points[i+1], points[i+2], points[i+3])
        end
        
        -- Rysuj ścieżkę patrolu
        love.graphics.setColor(0, 0, 1, 0.5)
        for i = 1, #self.patrolPoints do
            local nextPoint = i == #self.patrolPoints and 1 or i + 1
            love.graphics.line(
                self.patrolPoints[i].x, 
                self.patrolPoints[i].y, 
                self.patrolPoints[nextPoint].x, 
                self.patrolPoints[nextPoint].y
            )
            love.graphics.circle("fill", self.patrolPoints[i].x, self.patrolPoints[i].y, 5)
        end
    end
    
    -- Przywróć domyślny kolor
    love.graphics.setColor(1, 1, 1, 1)
end

function Enemy:update(dt)
    -- Aktualizuj położenie na podstawie ciała fizycznego
    self.x, self.y = self.body:getPosition()
    
    -- Timer strzału
    self.last_shot_time = self.last_shot_time - dt
    
    -- Timer losowości ruchu
    self.randomMovementTimer = self.randomMovementTimer - dt
    if self.randomMovementTimer <= 0 then
        self.randomMovementTimer = self.randomMovementInterval
        self.randomMovementOffset = {
            x = math.random(-20, 20),
            y = math.random(-20, 20)
        }
    end
    
    -- Sprawdź, czy gracz jest w polu widzenia
    local canSeePlayer = self:isPlayerInSight()
    
    -- Maszyna stanów
    if self.mode == "patrol" then
        if canSeePlayer then
            self.mode = "chase"
            self.targetLastSeen.x = player.x
            self.targetLastSeen.y = player.y
        else
            self:patrol(dt)
        end
    elseif self.mode == "chase" then
        if canSeePlayer then
            self.targetLastSeen.x = player.x
            self.targetLastSeen.y = player.y
            
            -- Jeśli gracz jest w zasięgu ataku, przejdź do trybu ataku
            local distToPlayer = self:distanceTo(player.x, player.y)
            if distToPlayer <= self.attackRange then
                self.mode = "attack"
            else
                self:chase(dt)
            end
        else
            -- Podążaj do ostatniej znanej pozycji gracza
            local distToLastSeen = self:distanceTo(self.targetLastSeen.x, self.targetLastSeen.y)
            if distToLastSeen < 10 then
                -- Jeśli doszliśmy do ostatniego miejsca, gdzie widzieliśmy gracza, wróć do patrolowania
                self.mode = "patrol"
                self.currentWaitTime = 0
            else
                self:moveTowards(self.targetLastSeen.x, self.targetLastSeen.y, self.speed * dt)
            end
        end
    elseif self.mode == "attack" then
        if canSeePlayer then
            self.targetLastSeen.x = player.x
            self.targetLastSeen.y = player.y
            
            local distToPlayer = self:distanceTo(player.x, player.y)
            if distToPlayer <= self.attackRange then
                self:attack(dt)
            else
                self.mode = "chase"
            end
        else
            self.mode = "chase"
        end
    end
    
    -- Obracaj w kierunku ruchu lub celu
    self:updateRotation()
end

-- Funkcja sprawdzająca, czy gracz jest w polu widzenia
function Enemy:isPlayerInSight()
    local distToPlayer = self:distanceTo(player.x, player.y)
    
    -- Sprawdź odległość
    if distToPlayer > self.visionRange then
        return false
    end
    
    -- Sprawdź kąt widzenia
    local angleToPlayer = math.atan2(player.y - self.y, player.x - self.x)
    local angleDiff = math.abs(self:normalizeAngle(angleToPlayer - self.angle))
    
    if angleDiff > self.visionAngle/2 then
        return false
    end
    
    -- Sprawdź czy nic nie blokuje widoku (linia wzroku)
    local hasLineOfSight = true
    -- TODO: Zaimplementuj wykrywanie kolizji między przeciwnikiem a graczem
    -- world:rayCast(self.x, self.y, player.x, player.y, function(fixture, x, y, xn, yn, fraction)
    --     if fixture:getUserData() ~= player then
    --         hasLineOfSight = false
    --         return 0
    --     end
    --     return 1
    -- end)
    
    return hasLineOfSight
end

-- Funkcja normalizująca kąt do zakresu -π do π
function Enemy:normalizeAngle(angle)
    while angle > math.pi do angle = angle - 2 * math.pi end
    while angle < -math.pi do angle = angle + 2 * math.pi end
    return angle
end

-- Zachowanie podczas patrolowania
function Enemy:patrol(dt)
    local currentPoint = self.patrolPoints[self.currentPatrolPoint]
    local distToPoint = self:distanceTo(currentPoint.x, currentPoint.y)
    
    if self.isRotating then
        -- Jesteśmy w trybie obracania się
        local rotationThisFrame = self.rotationSpeed * dt
        self.rotationAmount = self.rotationAmount + rotationThisFrame
        
        -- Obracaj się w wybranym kierunku
        self.angle = self.angle + rotationThisFrame * self.rotationDirection
        
        -- Normalizuj kąt
        self.angle = self:normalizeAngle(self.angle)
        
        -- Sprawdź czy zakończyliśmy pełny obrót (2*pi radianów)
        if self.rotationAmount >= 2 * math.pi then
            -- Zakończ obrót i przejdź do następnego punktu
            self.isRotating = false
            self.rotationAmount = 0
            self.currentPatrolPoint = self.currentPatrolPoint % #self.patrolPoints + 1
            self.currentWaitTime = 0
        end
        
        -- Zatrzymaj się podczas obracania
        self.body:setLinearVelocity(0, 0)
    else
        -- Normalny tryb patrolowania
        if distToPoint < 20 then
            -- Dotarliśmy do punktu patrolowego
            self.currentWaitTime = self.currentWaitTime + dt
            
            if self.currentWaitTime >= self.patrolWaitTime then
                -- Rozpocznij obracanie się
                self.isRotating = true
                self.rotationAmount = 0
                
                -- Losowo wybierz kierunek obrotu
                if math.random() > 0.5 then
                    self.rotationDirection = 1
                else
                    self.rotationDirection = -1
                end
            end
            
            -- Zatrzymaj się w punkcie patrolowym
            self.body:setLinearVelocity(0, 0)
        else
            -- Idź do aktualnego punktu patrolowego
            self:moveTowards(currentPoint.x, currentPoint.y, self.speed * dt)
        end
    end
end

-- Zachowanie podczas pościgu
function Enemy:chase(dt)
    -- Dodaj losowy ruch dla bardziej naturalnego zachowania
    local targetX = player.x + self.randomMovementOffset.x
    local targetY = player.y + self.randomMovementOffset.y
    
    self:moveTowards(targetX, targetY, self.chaseSpeed * dt)
end

-- Zachowanie podczas ataku
function Enemy:attack(dt)
    -- Obróć się w kierunku gracza
    local angleToPlayer = math.atan2(player.y - self.y, player.x - self.x)
    self.angle = angleToPlayer
    
    -- Utrzymuj dystans, poruszając się losowo
    local distToPlayer = self:distanceTo(player.x, player.y)
    local optimalDistance = self.attackRange * 0.7 -- Staramy się utrzymać 70% zasięgu ataku
    local tolerance = 30 -- Tolerancja odległości, aby zapobiec trzęsieniu
    
    if distToPlayer < optimalDistance - tolerance then
        -- Odsuń się od gracza
        local angle = angleToPlayer + math.pi -- Odwróć kąt
        local moveX = self.x + math.cos(angle) * self.speed * dt * 0.5
        local moveY = self.y + math.sin(angle) * self.speed * dt * 0.5
        self:moveTowards(moveX, moveY, self.speed * dt * 0.5)
    elseif distToPlayer > optimalDistance + tolerance then
        -- Zbliż się do gracza
        self:moveTowards(player.x, player.y, self.speed * dt * 0.7)
    else
        -- Jesteśmy w optymalnej odległości - zatrzymaj się i tylko strzelaj
        self.body:setLinearVelocity(0, 0)
        
        -- Możemy dodać drobny losowy ruch dla realizmu
        if math.random() < 0.1 then  -- 10% szans na losowy ruch
            local angle = angleToPlayer + math.random() * math.pi - math.pi/2
            local moveX = self.x + math.cos(angle) * self.speed * dt * 0.1
            local moveY = self.y + math.sin(angle) * self.speed * dt * 0.1
            self:moveTowards(moveX, moveY, self.speed * dt * 0.1)
        end
    end
    
    -- Strzelaj gdy cooldown minie
    if self.last_shot_time <= 0 then
        self:shoot()
        self.last_shot_time = self.shoot_cooldown
    end
end

-- Poruszanie się w kierunku celu
function Enemy:moveTowards(targetX, targetY, speed)
    local dx = targetX - self.x
    local dy = targetY - self.y
    local dist = math.sqrt(dx*dx + dy*dy)
    
    if dist > 0 then
        dx = dx / dist
        dy = dy / dist
        
        self.body:setLinearVelocity(dx * speed, dy * speed)
    else
        self.body:setLinearVelocity(0, 0)
    end
end

-- Obliczanie odległości do punktu
function Enemy:distanceTo(x, y)
    local dx = x - self.x
    local dy = y - self.y
    return math.sqrt(dx*dx + dy*dy)
end

-- Aktualizacja obrotu przeciwnika
function Enemy:updateRotation()
    if self.mode == "patrol" then
        -- Obróć w kierunku ruchu
        local vx, vy = self.body:getLinearVelocity()
        if math.abs(vx) > 5 or math.abs(vy) > 5 then
            self.angle = math.atan2(vy, vx)
        end
    else
        -- Obróć w kierunku gracza lub ostatniej znanej pozycji
        local targetX, targetY
        
        if self.mode == "attack" or self:isPlayerInSight() then
            targetX = player.x
            targetY = player.y
        else
            targetX = self.targetLastSeen.x
            targetY = self.targetLastSeen.y
        end
        
        self.angle = math.atan2(targetY - self.y, targetX - self.x)
    end
end

-- Funkcja strzelania
function Enemy:shoot()
    -- Oblicz pozycję końca broni
    local gunOffset = 25  -- Odległość od środka przeciwnika do końca broni
    local bulletX = self.x + math.cos(self.angle) * gunOffset
    local bulletY = self.y + math.sin(self.angle) * gunOffset
    
    -- Dodaj losowość do strzału (większa im dalej od gracza)
    local distToPlayer = self:distanceTo(player.x, player.y)
    local accuracy = math.max(0.95, 1 - (distToPlayer / (self.visionRange * 2)))
    local randomAngle = self.angle + (math.random() - 0.5) * (1 - accuracy) * 0.2
    
    -- Stwórz pocisk
    local bullet = {
        x = bulletX,
        y = bulletY,
        angle = randomAngle,
        speed = 1200,
        damage = 10,
        radius = 5,
        time_to_remove = 3,  -- Pocisk zniknie po 3 sekundach
        
        update = function(self, dt)
            self.x = self.x + math.cos(self.angle) * self.speed * dt
            self.y = self.y + math.sin(self.angle) * self.speed * dt
            self.time_to_remove = self.time_to_remove - dt
            
            -- Sprawdź kolizję z graczem
            local dx = player.x - self.x
            local dy = player.y - self.y
            local dist = math.sqrt(dx*dx + dy*dy)
            
            if dist < self.radius + player.shape:getRadius() then
                -- Sprawdź, czy funkcja istnieje lub użyj bezpiecznej alternatywy
                if player.TakeDamage then
                    player:TakeDamage(self.damage)
                else
                    -- Alternatywna implementacja obrażeń
                    player.hp = player.hp - self.damage
                    if player.hp < 0 then player.hp = 0 end
                end
                self.time_to_remove = 0
            end
        end,
        
        draw = function(self)
            love.graphics.setColor(1, 0, 0)
            love.graphics.circle("fill", self.x, self.y, self.radius)
            love.graphics.setColor(1, 1, 1)
        end
    }
    
    -- Dodaj pocisk do tabeli pocisków
    table.insert(enemy_bullets, bullet)
    
    -- Debugowanie
    print("Przeciwnik strzelił! Pozycja: " .. bulletX .. ", " .. bulletY)
end

function Enemy:TakeDamage(damage)
    self.hp = self.hp - damage
    if self.hp <= 0 then
        -- Oznacz przeciwnika do usunięcia, zamiast próbować go usunąć tutaj
        self.toRemove = true
        
        -- Zniszcz ciało fizyczne przeciwnika
        if self.body and not self.body:isDestroyed() then
            self.body:destroy()
        end
        
        -- Opcjonalnie: efekty śmierci
        print("Przeciwnik został pokonany!")
        
        -- Opcjonalnie: punkty, doświadczenie itp.
        -- player.score = player.score + self.scoreValue
        enemy = nil
    end
end

return Enemy