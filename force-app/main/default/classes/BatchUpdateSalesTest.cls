@isTest
private class BatchUpdateSalesTest {
  @TestSetup
  static void setup() {
    TestDataFactory df = new TestDataFactory();
  }
  @isTest
  static void testBatchUpdateSales() {
    // Create 15 accounts with 10 orders for each of them.
    Test.startTest();
    TestDataFactory.createOrders(15, 10, 'Ordered');
    BatchUpdateSales batch = new BatchUpdateSales();
    Id batchId = Database.executeBatch(batch);
    Test.stopTest();

    Account testAccountAfterUpdate = [
      SELECT Id, Chiffre_d_affaire__c
      FROM Account
      WHERE Name LIKE 'TestAccount%'
      LIMIT 1
    ];
    // As orders' Net Amount = 100, Account CA should be 1000.
    System.assertEquals(1000, testAccountAfterUpdate.Chiffre_d_affaire__c);
  }
  @isTest
  static void testBatchUpdateSalesWithDraftOrders() {
    // Create 15 accounts with 10 orders for each of them.
    Test.startTest();
    TestDataFactory.createOrders(15, 10, 'Draft');
    BatchUpdateSales batch = new BatchUpdateSales();
    Id batchId = Database.executeBatch(batch);
    Test.stopTest();

    Account testAccountAfterUpdate = [
      SELECT Id, Chiffre_d_affaire__c
      FROM Account
      WHERE Name LIKE 'TestAccount%'
      LIMIT 1
    ];
    // As orders' status is Draft, Account CA should be 0.
    System.assertEquals(null, testAccountAfterUpdate.Chiffre_d_affaire__c);
  }
}
