$(document).ready(function() {
  handlePhone = (event) => {
    let input = event.target
    input.value = phoneMask(input.value)
  }  
  phoneMask = (value) => {
    if (!value) return ""
    value = value.replace(/\D/g,'')
    value = value.replace(/(\d{2})(\d)/,"($1) $2")
    value = value.replace(/(\d)(\d{4})$/,"$1-$2")
    return value
  }

  handleUF = (event) => {
    let input = event.target
    input.value = ufMask(input.value)
  }
  ufMask = (value) => {
    if (!value) return ""
    value = value.replace(/\d/g, "");
    value = value.slice(0, 2);
    value = value.replace(/[^\w\s]/gi, "");
    return value.toUpperCase();
  }

  handleCNPJ = (event) => {
    let input = event.target
    input.value = cnpjMask(input.value)
  }
  cnpjMask = (value) => {
    if (!value) return ""
    value = value.replace(/\D/g,'')
    value = value.replace(/(\d{2})(\d)/,"$1.$2")
    value = value.replace(/(\d{3})(\d)/,"$1.$2")
    value = value.replace(/(\d{3})(\d)/,"$1/$2")
    value = value.replace(/(\d{4})(\d)/,"$1-$2")
    return value
  }

  handleCPF = (event) => {
    let input = event.target
    input.value = cpfMask(input.value)
  }
  cpfMask = (value) => {if (!value) return "";  
    value = value.replace(/\D/g, '');
    value = value.replace(/(\d{3})(\d)/, "$1.$2");6
    value = value.replace(/(\d{3})(\d)/, "$1.$2");
    value = value.replace(/(\d{3})(\d{1,2})$/, "$1-$2");
    return value;
  }
  
  handleInscEstadual = (event) => {
    let input = event.target
    input.value = inscEstadualMask(input.value)
  }
  inscEstadualMask = (value) => {
    if (!value) return ""
    value = value.replace(/\D/g,'')
    value = value.replace(/(\d{3})(\d)/,"$1.$2")
    value = value.replace(/(\d{3})(\d)/,"$1.$2")
    return value
  }
});
