$(document).ready(function() {
  handleMoney = (event) => {
    let input = event.target;
    input.value = moneyMask(input.value);
  };
  moneyMask = (value) => {
    if (!value) return '';
    value = value.replace(/\D/g, '');
    value = (value / 100).toLocaleString('pt-BR', {
      style: 'currency',
      currency: 'BRL',
    });
    return value;
  };
});