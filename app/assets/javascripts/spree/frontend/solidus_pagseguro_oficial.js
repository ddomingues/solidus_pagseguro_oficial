SpreePagSeguro = function(paymentMethodID) {

    function isSelected(paymentMethod) {
        return paymentMethodID && paymentMethod == paymentMethodID
    }

    function showOrHide(selector) {
        return function() {
            var paymentMethod = $(this).val();
            $(selector)[  isSelected(paymentMethod) ? 'hide' : 'show' ]();
        }
    }

    return {
        showOrHide: showOrHide
    }

}