BOMBERMAN_MINIGAME = {
    player_cache = {
        --[454545] = {speed = 100, range = 1, bomb = 1, bombs = {}, kill = 1, death = false, ingame = true, map = 1}
    },
    items_cache = {
        --{itemid = 6541, pos = Position(0,0,0)}
    },
    
    bomb_id = 9468,
    protected_items = {10755},
    explosive_items = {10744}, 
    
    drop_item_chance = 40,
    speed_up_item = {itemid = 2195, up = 100},
    range_up_item = {itemid = 8304, up = 1},
    bomb_up_item = {itemid = 31344, up = 1},
    
    movement_actionid = 4544,
    
    base_range = 1,
    base_speed = 150,
    base_bomb = 1,
    
    explode_text = "BOOM!",
    explode_time = 3000,
    explode_effect = 7,
    explode_other_bomb_interval = 300,
    exploded_item_remove_time = 300,
    exploded_item_remove_effect = 1,
    exploded_upgrade_item_effect = 28,
    
    map_rebuild_time = 5000, 
    rebuilding_map = false, --don't change
            
    moneyCost = 0,
    
    spectators = true,
    
    channelId = 30,
    
    messages = {
        bomb_explode = {msg = "BOOM!", type = TALKTYPE_MONSTER_SAY},
        bomb_kill = {msg = "[BOMBERMAN] Voce matou %s.", type = MESSAGE_STATUS_CONSOLE_BLUE},
        bomb_death = {msg = "[BOMBERMAN] Voce foi morto por %s !.", type = MESSAGE_STATUS_CONSOLE_BLUE},
        bomb_suicide = {msg = "[BOMBERMAN] Voce se suicidou.", type = MESSAGE_STATUS_CONSOLE_BLUE},
        movement_powerup = {msg = "[BOMBERMAN] Voce ficou mais forte", type = MESSAGE_STATUS_CONSOLE_BLUE},
        press_lever_enter = {msg = "[BOMBERMAN] Bem vindo ao bomberman, para colocar a bomba digite !bomb.", type = MESSAGE_EVENT_ADVANCE},
        press_lever_no_map = {msg = "[BOMBERMAN] Nao esta disponivel no momento.", type = MESSAGE_STATUS_CONSOLE_BLUE},
        press_lever_no_players = {msg = "[BOMBERMAN] Voce precisa de mais jogadores para jogar o bomberman.", type = MESSAGE_STATUS_CONSOLE_BLUE},
        press_lever_rebuilding_map = {msg = "[BOMBERMAN] Espere acabar a partida.", type = MESSAGE_STATUS_CONSOLE_BLUE},
        press_lever_no_money = {msg = "[BOMBERMAN] Voce precisa %d de dinheiro para jogar o Bomberman.", type = MESSAGE_STATUS_CONSOLE_BLUE},
        press_lever_cant_play = {msg = "[BOMBERMAN] Voce nao pode jogar o Bomberman.", type = MESSAGE_STATUS_CONSOLE_BLUE},
        talkaction_not_in_minigame = {msg = "[BOMBERMAN] Voce precisa estar dentro do jogo bomberman para usar este comando.", type = MESSAGE_STATUS_CONSOLE_BLUE},
        talkaction_dont_have_bombs = {msg = "[BOMBERMAN] Voce nao tem mais bombas.", type = MESSAGE_STATUS_CONSOLE_BLUE},
        talkaction_cant_place_bomb = {msg = "[BOMBERMAN] Voce nao pode colocar uma bomba aqui.", type = MESSAGE_STATUS_CONSOLE_BLUE}, 
        talkaction_place_bomb = {msg = "[BOMBERMAN] Voce colocou uma bomba, bombas restante: %d.", type = MESSAGE_STATUS_CONSOLE_BLUE},
        talkaction_death_place_bomb = {msg = "[BOMBERMAN] voce esta morto, nao pode colocar uma bomba.", type = MESSAGE_STATUS_CONSOLE_BLUE},
        channel_enter = {msg = "[BOMBERMAN] Bem vindo ao canal do bomberman aqui, voce recebera todas as info.", type = TALKTYPE_CHANNEL_O},
        channel_leave = {msg = "[BOMBERMAN] Voce nao pode fechar o canal bomberman enquanto esta no jogo.", type = TALKTYPE_CHANNEL_O},
        channel_winner = {msg = "[BOMBERMAN] %s Voce Venceu!", type = TALKTYPE_CHANNEL_O},
        
        channel_powerup = {msg = "[BOMBERMAN] %s voce esta mais forte!", type = TALKTYPE_CHANNEL_O},
        channel_suicide = {msg = "[BOMBERMAN] %s cometeu suicidio.", type = TALKTYPE_CHANNEL_O},
        channel_kill = {msg = "[BOMBERMAN] %s matou %s.", type = TALKTYPE_CHANNEL_O},
    },
    
    
    reward = {
        --{itemid = 2160, count = 10},
        {itemid = 2160, count = 10}
    },
    
    player_tiles = {
        [1] = Position(1155, 1012, 6),
        [2] = Position(1156, 1012, 6),
        [3] = Position(1157, 1012, 6),
        [4] = Position(1158, 1012, 6),

    },
    
    
    maps = {
        [1] = {
            player_death_spec_pos = Position(1157, 985, 6),
            players_positions = {
        [1] = Position(1150, 990, 7),
        [2] = Position(1164, 990, 7),
        [3] = Position(1164, 980, 7),
        [4] = Position(1150, 980, 7),
            }
        }
        
    }
    
}


local function checkItems(items, itemids)
    for k, v in pairs(items) do
        for l, b in pairs(itemids) do
            if v:getId() == b then
                return true
            end
        end
    end
    return false
end

function Player:bombermanPlantBomb()
    local pos = self:getPosition() 
    local item = Game.createItem(BOMBERMAN_MINIGAME.bomb_id, 1, pos)
    table.insert(BOMBERMAN_MINIGAME.player_cache[self:getId()].bombs, pos)
    
    addEvent(function()
        if BOMBERMAN_MINIGAME.player_cache[self:getId()] then
            if isInArray(BOMBERMAN_MINIGAME.player_cache[self:getId()].bombs, pos) then
                pos:bombermanParseExplodeArea(self)
                pos:bombermanExplode(pos, self)
            end
        else
            item:remove(item:getCount())
        end
    end, BOMBERMAN_MINIGAME.explode_time) 
end

function Position:bombermanParseExplodeArea(player)
    local cache = BOMBERMAN_MINIGAME.player_cache[player:getId()]
    
    if not cache then
        return
    end
    
    for k, v in pairs(BOMBERMAN_MINIGAME.player_cache) do
        if v.map == cache.map then
            for i = 1, #v.bombs do
                if v.bombs[i] == self then
                    table.remove(v.bombs, i)
                end
            end
        end
    end
    
    local paths = {
        {calc = {x = -1, y = 0}, active = true},
        {calc = {x = 0, y = 1}, active = true},
        {calc = {x = 1, y = 0}, active = true},
        {calc = {x = 0, y = -1}, active = true}
    }
    
    self:sendMagicEffect(BOMBERMAN_MINIGAME.explode_effect)
    for r = 1, cache.range do
        for p = 1, #paths do
            if paths[p].active then
                local pos = Position(self.x+(r*paths[p].calc.x), self.y+(r*paths[p].calc.y), self.z)
                local tile = Tile(pos)
                local items = tile and tile:getItems() or {}
                
                if #items > 0 then
                    if checkItems(items, BOMBERMAN_MINIGAME.protected_items) then
                        paths[p].active = false
                    elseif checkItems(items, BOMBERMAN_MINIGAME.explosive_items) then
                        pos:bombermanExplode(self, player)
                        paths[p].active = false
                    else
                        pos:bombermanExplode(self, player)
                    end
                elseif tile then
                    pos:bombermanExplode(self, player)
                end
            end
        end
    end 
    
    local spectators = Game.getSpectators(self, false, true, 4, 4)
    
    for _, spectator in ipairs(spectators) do
        player:say(BOMBERMAN_MINIGAME.messages.bomb_explode.msg, BOMBERMAN_MINIGAME.messages.bomb_explode.type, false, spectator, self)
    end
end

function Position:bombermanExplode(defpos, player)
    local tile = Tile(self)
    local item = tile and tile:getItems() or {}
    local cache = BOMBERMAN_MINIGAME.player_cache[player:getId()]
    
    if not cache then
        if tile:getItemById(BOMBERMAN_MINIGAME.bomb_id) then
            tile:getItemById(BOMBERMAN_MINIGAME.bomb_id):remove(1)
        end
        return
    end
    
    local map = cache.map
    
    self:sendMagicEffect(BOMBERMAN_MINIGAME.explode_effect)
    for i = 1, tile:getItemCount() do
        if isInArray(BOMBERMAN_MINIGAME.explosive_items, item[i]:getId()) then
            addEvent(function()
                self:sendMagicEffect(BOMBERMAN_MINIGAME.exploded_item_remove_effect)
                table.insert(BOMBERMAN_MINIGAME.items_cache, {itemid = item[i]:getId(), pos = self, map = map})
                item[i]:remove(item[i]:getCount())
                
                local rand = math.random(1, 100)
                if rand <= BOMBERMAN_MINIGAME.drop_item_chance then
                    local upgrade = {BOMBERMAN_MINIGAME.speed_up_item, BOMBERMAN_MINIGAME.range_up_item, BOMBERMAN_MINIGAME.bomb_up_item}
                    upgrade = upgrade[math.random(1, #upgrade)]
                    
                    local item = Game.createItem(upgrade.itemid, 1, self)
                    item:setActionId(BOMBERMAN_MINIGAME.movement_actionid)
                    self:sendMagicEffect(BOMBERMAN_MINIGAME.exploded_upgrade_item_effect)
                end 
            end, BOMBERMAN_MINIGAME.exploded_item_remove_time)
            break
        elseif defpos == self and item[i]:getId() == BOMBERMAN_MINIGAME.bomb_id then
            item[i]:remove(item[i]:getCount())
        elseif item[i]:getId() == BOMBERMAN_MINIGAME.bomb_id and defpos ~= self then
            item[i]:remove(item[i]:getCount())
            self:bombermanParseExplodeArea(player)
        elseif isInArray({BOMBERMAN_MINIGAME.speed_up_item.itemid, BOMBERMAN_MINIGAME.range_up_item.itemid, BOMBERMAN_MINIGAME.bomb_up_item.itemid}, item[i]:getId()) then
            item[i]:remove(item[i]:getCount())
            self:sendMagicEffect(BOMBERMAN_MINIGAME.exploded_upgrade_item_effect)
        end
    end 
    
    local kill = tile:getTopCreature()
    local killcache = kill and kill:isPlayer() and BOMBERMAN_MINIGAME.player_cache[kill:getId()] or false
    
    if killcache then
        
        if kill:getId() ~= player:getId() then
            cache.kill = cache.kill+1
            kill:sendTextMessage(BOMBERMAN_MINIGAME.messages.bomb_death.type, string.format(BOMBERMAN_MINIGAME.messages.bomb_death.msg, player:getName()))
            player:sendTextMessage(BOMBERMAN_MINIGAME.messages.bomb_kill.type, string.format(BOMBERMAN_MINIGAME.messages.bomb_kill.msg, kill:getName()))
            player:sendChannelMessage("", string.format(BOMBERMAN_MINIGAME.messages.channel_kill.msg, player:getName(), kill:getName()), BOMBERMAN_MINIGAME.messages.channel_kill.type, BOMBERMAN_MINIGAME.channelId)
        else
            player:sendTextMessage(BOMBERMAN_MINIGAME.messages.bomb_suicide.type, BOMBERMAN_MINIGAME.messages.bomb_suicide.msg)
            player:sendChannelMessage("", string.format(BOMBERMAN_MINIGAME.messages.channel_suicide.msg, player:getName()), BOMBERMAN_MINIGAME.messages.channel_suicide.type, BOMBERMAN_MINIGAME.channelId)
        end
        
        killcache.death = true
        kill:changeSpeed(-kill:getSpeed())
        kill:changeSpeed(killcache.speed)
        
        if BOMBERMAN_MINIGAME.spectators then
            kill:teleportTo(BOMBERMAN_MINIGAME.maps[map].player_death_spec_pos)
        else
            kill:teleportTo(kill:getTown():getTemplePosition())
            kill:bombermanSave()
            killcache.ingame = false
        end
        
        local players = 0
        
        for k, v in pairs(BOMBERMAN_MINIGAME.player_cache) do
            if not v.death and v.map == map then
                players = players+1
            end
        end
        
        if players == 1 then
            player:sendChannelMessage("", string.format(BOMBERMAN_MINIGAME.messages.channel_winner.msg, player:getName()), BOMBERMAN_MINIGAME.messages.channel_winner.type, BOMBERMAN_MINIGAME.channelId)
            
            for k, v in pairs(BOMBERMAN_MINIGAME.reward) do
                player:addItem(v.itemid, v.count)
            end
            
            
            if BOMBERMAN_MINIGAME.spectators then
                for k, v in pairs(BOMBERMAN_MINIGAME.player_cache) do
                    if v.map == map then
                        Player(k):teleportTo(Player(k):getTown():getTemplePosition())
                    end
                end
            else
                if BOMBERMAN_MINIGAME.player_cache[player:getId()].ingame then
                    player:teleportTo(player:getTown():getTemplePosition())
                end
            end
            
            BOMBERMAN_MINIGAME.rebuilding_map = true
            
            addEvent(function()
                for k, v in pairs(BOMBERMAN_MINIGAME.items_cache) do
                    if v.map == map then
                        local item = Tile(v.pos):getItems()
                        for i = 1, #item do
                            item[i]:remove(item[i]:getCount())
                        end
                        Game.createItem(v.itemid, 1, v.pos)
                        BOMBERMAN_MINIGAME.items_cache[k] = nil
                    end
                end
                
                for k, v in pairs(BOMBERMAN_MINIGAME.player_cache) do
                    if v.map == map then
                        BOMBERMAN_MINIGAME.player_cache[k] = nil
                    end
                end
                BOMBERMAN_MINIGAME.rebuilding_map = false
            end, BOMBERMAN_MINIGAME.map_rebuild_time)
        end
    end
end
