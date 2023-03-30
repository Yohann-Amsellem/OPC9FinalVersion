@isTest
public with sharing class MyTeamOrdersControllerTest {

    @TestSetup
    static void setup() {
        TestDataFactory df = new TestDataFactory();
    }

    @isTest
    static void TestShowTotalOrdersNetAmount() {
        // Create one account with one ordered order
        TestDataFactory.createOrders(1, 1, 'Ordered');
        MyTeamOrdersController test = new MyTeamOrdersController();

        // Total amount should equals to 100
        System.assertEquals(100, test.ShowTotalOrdersNetAmount);
    }

    @isTest
    static void TestShowTotalOrdersNetAmountWithDraftOrders() {
        // Create one account with one ordered order
        TestDataFactory.createOrders(1, 1, 'Draft');
        MyTeamOrdersController test = new MyTeamOrdersController();

        // As orders' status is Draft, the function should return nothing.
        System.assertEquals(null, test.ShowTotalOrdersNetAmount);
    }
}