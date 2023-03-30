trigger OrderTrigger on Order (before update, after update ) {
    if (Trigger.isBefore) {
        OrderHandler.calculateNetAmount(Trigger.new);

    } else if (Trigger.isAfter) {
        OrderHandler.UpdateAccountCA(Trigger.new);
        }
}