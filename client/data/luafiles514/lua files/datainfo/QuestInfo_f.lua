-- FoxHT: Fixed QuestInfo_f.lua for Pre-Renewal
-- Prevents "attempt to index field '?' (a nil value)" errors

function GetOngoingQuestInfoByID(questID)
    local questInfo = QuestTable[questID]
    if questInfo == nil then
        return ""
    end
    return questInfo
end

function GetQuestInfoByID(questID)
    local questInfo = QuestTable[questID]
    if questInfo == nil then
        return ""
    end
    return questInfo
end
