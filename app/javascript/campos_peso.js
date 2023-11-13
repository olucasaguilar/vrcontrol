$(document).ready(function() {
  handleWeight = (event) => {
    let input = event.target;
    let value = weightMask(input.value);
    input.value = value;
  };
  weightMask = (value) => {
    if (!value) return "";
    value = value.replace(/\D/g, "");
    value = value.replace(/(\d)(\d{2})$/, "$1,$2");
    return value;
  };
});