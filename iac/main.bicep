param funcAppName string
param serverFarmName string
param stgAcctName string
param svcBusNamespace string
param rgLocation string = resourceGroup().location

module stg 'storageAccounts/deploy.bicep' = {
  name: 'deployStorageAccounts'
  params: {
    name: stgAcctName
    location: rgLocation
  }
}

module svcPlan 'serverfarms/deploy.bicep' = {
  name: 'deploySvcPlan'
  params: {
    name: serverFarmName
    location: rgLocation
    sku: {
      capacity: 0
      family: 'Y'
      name: 'Y1'
      size: 'Y1'
      tier: 'Dynamic'
    }
    serverOS: 'Linux'

  }
}

module funcApp 'sites/deploy.bicep' = {
  name: 'deployFuncApp'
  dependsOn: [
    svcPlan
    stg
  ]
  params: {
    name: funcAppName
    kind: 'functionapp,linux'
    location: rgLocation
    serverFarmResourceId: svcPlan.outputs.resourceId
    storageAccountId: stg.outputs.resourceId
  }
}

module svcBus 'serviceBus/deploy.bicep' = {
  name: 'deploySvcBus'
  params: {
    name: svcBusNamespace
    location: rgLocation
    skuName: 'Standard'
    systemAssignedIdentity: true
    queues: [
      {
        authorizationRules: [
          {
            name: 'RootManageSharedAccessKey'
            rights: [
              'Listen'
              'Manage'
              'Send'
            ]
          }
          {
            name: 'AnotherKey'
            rights: [
              'Listen'
              'Send'
            ]
          }
        ]
        name: 'test-queue-01'
      }
    ]
  }
}

module logicApp 'logicApp/deploy.bicep' = {
  name: 'deployLogicApp'
  params: {
    name: 'workflow-test-01'
    location: rgLocation
    systemAssignedIdentity: true
  }
}
