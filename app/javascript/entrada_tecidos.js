function copiarOpcoes(origemId) {
  const origemSelect = document.getElementById(origemId);
  const opcoes = origemSelect.cloneNode(true); // Clona o elemento select com todas as opções
  const opcoesSelecionadas = opcoes.querySelectorAll('option[selected="selected"]');

  // Remove o atributo selected de todas as opções selecionadas no clone
  opcoesSelecionadas.forEach((opcao) => {
    opcao.removeAttribute('selected');
  });

  return opcoes.innerHTML;
}

document.addEventListener("DOMContentLoaded", function () {
  objetosAdicionais = document.getElementById('objetos-adicionais');
  botaoMaisObjeto = document.getElementById('botao-mais-tecido');
  
  maxObjetoIndex = 0;
  objetosAdicionais.querySelectorAll('select').forEach(function(select) {
    const match = select.id.match(/fabric_stock(\d+)_tipo_tecido_id/);
    if (match && parseInt(match[1]) > maxObjetoIndex) {
      maxObjetoIndex = parseInt(match[1]);
    }
  });

  objetoIndex = maxObjetoIndex + 1;

  botaoMaisObjeto.addEventListener('click', function() {
    const novoObjetoHTML = `
      <p>Tecido ${objetoIndex+1}</p>
      
      <p>
        <label for="fabric_stock${objetoIndex}_tipo_tecido_id">Tipo de Tecido</label>
        <select name="fabric_stock${objetoIndex}[tipo_tecido_id]" id="fabric_stock${objetoIndex}_tipo_tecido_id" class="form-control">
          ${copiarOpcoes('fabric_stock_tipo_tecido_id')}
        </select>
      </p>

      <p>
        <label for="fabric_stock${objetoIndex}_cor_id">Cor</label>
        <select name="fabric_stock${objetoIndex}[cor_id]" id="fabric_stock${objetoIndex}_cor_id" class="form-control">
          ${copiarOpcoes('fabric_stock_cor_id')}
        </select>
      </p>

      <p>
        <label for="fabric_stock${objetoIndex}_quantidade">Quantidade</label>
        <input type="text" name="fabric_stock${objetoIndex}[quantidade]" id="fabric_stock${objetoIndex}_quantidade" value="0" class="form-control">
      </p>
      <hr>
    `;
    
    const novoObjetoDiv = document.createElement('div');
    novoObjetoDiv.innerHTML = novoObjetoHTML;
    objetosAdicionais.appendChild(novoObjetoDiv);

    objetoIndex++; 
  });
}); 

objetosAdicionais = document.getElementById('objetos-adicionais');
botaoMaisObjeto = document.getElementById('botao-mais-tecido');

maxObjetoIndex = 0;
objetosAdicionais.querySelectorAll('select').forEach(function(select) {
  const match = select.id.match(/fabric_stock(\d+)_tipo_tecido_id/);
  if (match && parseInt(match[1]) > maxObjetoIndex) {
    maxObjetoIndex = parseInt(match[1]);
  }
});

objetoIndex = maxObjetoIndex + 1;

botaoMaisObjeto.addEventListener('click', function() {
  const novoObjetoHTML = `
    <p>Tecido ${objetoIndex+1}</p>
    
    <p>
      <label for="fabric_stock${objetoIndex}_tipo_tecido_id">Tipo de Tecido</label>
      <select name="fabric_stock${objetoIndex}[tipo_tecido_id]" id="fabric_stock${objetoIndex}_tipo_tecido_id" class="form-control">
        ${copiarOpcoes('fabric_stock_tipo_tecido_id')}
      </select>
    </p>
    
    <p>
      <label for="fabric_stock${objetoIndex}_cor_id">Cor</label>
      <select name="fabric_stock${objetoIndex}[cor_id]" id="fabric_stock${objetoIndex}_cor_id" class="form-control">
        ${copiarOpcoes('fabric_stock_cor_id')}
      </select>
    </p>

    <p>
      <label for="fabric_stock${objetoIndex}_quantidade">Quantidade</label>
      <input type="text" name="fabric_stock${objetoIndex}[quantidade]" id="fabric_stock${objetoIndex}_quantidade" value="0" class="form-control">
    </p>
    <hr>
  `;

  const novoObjetoDiv = document.createElement('div');
  novoObjetoDiv.innerHTML = novoObjetoHTML;
  objetosAdicionais.appendChild(novoObjetoDiv);
  
  objetoIndex++; 
});
