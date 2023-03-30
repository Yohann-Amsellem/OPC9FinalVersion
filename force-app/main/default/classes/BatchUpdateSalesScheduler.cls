global with sharing class BatchUpdateSalesScheduler implements Schedulable {
  global void execute(SchedulableContext ctx) {
    BatchUpdateSales batch = new BatchUpdateSales();
    Id batchId = Database.executeBatch(batch);
  }
}
