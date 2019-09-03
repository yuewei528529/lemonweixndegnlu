package com.mossle.api.party;

import org.springframework.stereotype.Service;

@Service
public class MockPartyConnector implements PartyConnector {
    public PartyDTO findById(String partyId) {
        return null;
    }
}
