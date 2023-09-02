function sanitizeInput(event) {
  // Obtém o valor atual do campo de entrada
  var inputValue = event.target.value;

  // Remove todos os caracteres que não sejam números, ponto ou vírgula
  var sanitizedValue = inputValue.replace(/[^0-9,]/g, '');

  // Garante que existam no máximo dois valores após a vírgula
  var parts = sanitizedValue.split(',');
  if (parts.length > 1) {
    sanitizedValue = parts[0] + ',' + parts[1].slice(0, 2);
  }

  // Define o valor do campo de entrada como o valor sanitizado
  event.target.value = sanitizedValue;
}

function convertCommaToDot() {
  // Obtém o valor do campo de entrada
  var valorInput = document.getElementById("valor-input").value;

  // Substitui todas as vírgulas por pontos
  valorInput = valorInput.replace(/,/g, '.');

  // Define o valor convertido de volta no campo de entrada
  document.getElementById("valor-input").value = valorInput;
}

window.onload = function () {
  // Obtém o elemento de entrada pelo ID
  var valorInput = document.getElementById("valor-input");

  // Adiciona um evento de escuta para cada vez que o valor muda
  valorInput.addEventListener("input", sanitizeInput);

  // Obtém o elemento de formulário pelo ID
  var form = document.getElementById("formulario");

  // Adiciona um evento de escuta para o evento de envio do formulário
  form.addEventListener("submit", convertCommaToDot);
};

// Fora do evento window.onload, você pode chamar as funções diretamente conforme necessário
var valorInput = document.getElementById("valor-input");
valorInput.addEventListener("input", sanitizeInput);

var form = document.getElementById("formulario");
form.addEventListener("submit", convertCommaToDot);