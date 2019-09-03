package com.mossle.api.tenant;

import org.springframework.stereotype.Service;

@Service
public interface TenantHolder {
    String getTenantId();

    String getTenantCode();

    String getUserRepoRef();

    TenantDTO getTenantDto();
}
