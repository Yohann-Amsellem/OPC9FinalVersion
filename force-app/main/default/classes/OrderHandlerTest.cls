@isTest
public with sharing class OrderHandlerTest {
    @TestSetup
    static void setup() {
        TestDataFactory df = new TestDataFactory();
    }       
    
    @isTest
    private static void UpdateAccountCATest() {
        // Create 2 Accounts with 225  draft orders each 
        Test.startTest();
        TestDataFactory.createOrders(2, 225, 'Draft');
        // Activate the orders to trigger the method   
        List<Order> orderListBeforeUpdate = new List<Order>();
        orderListBeforeUpdate = [ SELECT Id, Status FROM Order 
                                WHERE Account.Name 
                                LIKE 'TestAccount%'];
        for (Order orderToUpdate : orderListBeforeUpdate ){
            orderToUpdate.Status = 'Ordered';
        }
        update orderListBeforeUpdate;
        Test.stopTest();
        // Get a random account
        Account singleAccount = [ SELECT Id, Chiffre_d_affaire__c 
                                FROM Account WHERE Name 
                                LIKE 'TestAccount%' LIMIT 1 ];
        // As Orders' net amount is 100, result should be 22500 (225*100)
        System.assertEquals(22500, singleAccount.Chiffre_d_affaire__c);
    }

    @isTest
    static void calculateNetAmountTest() {
    Test.startTest();
    // Create 1 Account with 1 ordered order 
    TestDataFactory.createOrders(1, 1, 'Ordered');
    Test.stopTest();
    // Get a random order
    Order singleOrder = [ SELECT Id, NetAmount__c FROM Order 
                        WHERE Account.Name LIKE 'TestAccount%' LIMIT 1 ];
    // Result should be 100
    System.assertEquals(100, singleOrder.NetAmount__c);
    }

    @isTest
    static void calculateNetAmountTestWithBulkOrders() {
    Test.startTest();
    // Create 2 Accounts with 225 ordered orders each 
    TestDataFactory.createOrders(2, 225, 'Ordered');
    Test.stopTest();
    // Get the second account with Offset keyword
    Order singleOrder = [ SELECT Id, NetAmount__c, CreatedDate FROM Order 
                        WHERE Account.Name LIKE 'TestAccount%' 
                        ORDER BY CreatedDate DESC LIMIT 1 OFFSET 1 ];
    // Result should be 100
    System.assertEquals(100, singleOrder.NetAmount__c);
    }

    @isTest
    static void calculateNetAmountTestWithNullShipmentCost() {
    // Create 1 Account and 1 draft order
    TestDataFactory.createOrders(1, 1, 'Draft');
    Order orderToUpdate = [ SELECT Id, ShipmentCost__c FROM Order 
                        WHERE Account.Name LIKE 'TestAccount%' ];
    Test.startTest();
    // Set the Shipment Cost to null and update
    orderToUpdate.ShipmentCost__c = null;
    update orderToUpdate;
    Test.stopTest();
    // Get the order after update
    Order OrderAfterUpdate = [ SELECT Id,NetAmount__c FROM Order 
                            WHERE Account.Name LIKE 'TestAccount%' ];
    // Result should be 110
    System.assertEquals(110, OrderAfterUpdate.NetAmount__c);
    }
}