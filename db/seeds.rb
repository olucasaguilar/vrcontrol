# Tipos de tecidos
FabricType.find_or_create_by(nome: 'Malha')
FabricType.find_or_create_by(nome: 'Algodão')
FabricType.find_or_create_by(nome: 'Seda')
FabricType.find_or_create_by(nome: 'Lã')
FabricType.find_or_create_by(nome: 'Cetim')
FabricType.find_or_create_by(nome: 'Veludo')
FabricType.find_or_create_by(nome: 'Couro')
FabricType.find_or_create_by(nome: 'Jeans')
FabricType.find_or_create_by(nome: 'Flanela')
FabricType.find_or_create_by(nome: 'Tule')

# Cores
Color.find_or_create_by(nome: 'Preto')
Color.find_or_create_by(nome: 'Branco')
Color.find_or_create_by(nome: 'Vermelho')
Color.find_or_create_by(nome: 'Azul')
Color.find_or_create_by(nome: 'Amarelo')
Color.find_or_create_by(nome: 'Verde')
Color.find_or_create_by(nome: 'Rosa')
Color.find_or_create_by(nome: 'Laranja')
Color.find_or_create_by(nome: 'Roxo')

# Tipos de peças
GarmentType.find_or_create_by(nome: 'Camiseta')
GarmentType.find_or_create_by(nome: 'Calça')
GarmentType.find_or_create_by(nome: 'Bermuda')

# Tamanhos de peças
GarmentSize.find_or_create_by(nome: 'P')
GarmentSize.find_or_create_by(nome: 'M')
GarmentSize.find_or_create_by(nome: 'G')
GarmentSize.find_or_create_by(nome: 'GG')
GarmentSize.find_or_create_by(nome: 'XG')
GarmentSize.find_or_create_by(nome: 'XXG')

# Tipos de entidades
EntityType.find_or_create_by(nome: 'Malharia')
EntityType.find_or_create_by(nome: 'Cortador')
EntityType.find_or_create_by(nome: 'Costureira')
EntityType.find_or_create_by(nome: 'Serigrafia')
EntityType.find_or_create_by(nome: 'Acabamento')
EntityType.find_or_create_by(nome: 'Vendedor')
EntityType.find_or_create_by(nome: 'Transportadora')

# Exemplos de entidades do tipo 'Malharia'
Entity.find_or_create_by(nome: 'Malharia Fashion Ltda.', num_contato: '(11) 5555-1234', cidade: 'São Paulo', estado: 'SP', entity_types_id: 1)
Entity.find_or_create_by(nome: 'Tecidos Criativos S.A.', num_contato: '(21) 9876-5432', cidade: 'Rio de Janeiro', estado: 'RJ', entity_types_id: 1)
Entity.find_or_create_by(nome: 'Malharia Sulbrasileira', num_contato: '(47) 2222-8888', cidade: 'Blumenau', estado: 'SC', entity_types_id: 1)
Entity.find_or_create_by(nome: 'Tecelagem Estampada Ltda.', num_contato: '(31) 3333-4444', cidade: 'Belo Horizonte', estado: 'MG', entity_types_id: 1)
Entity.find_or_create_by(nome: 'Malhas do Sul Exportações', num_contato: '(54) 7777-9999', cidade: 'Caxias do Sul', estado: 'RS', entity_types_id: 1)

# Exemplos de entidades do tipo 'Cortador'
Entity.find_or_create_by(nome: 'Cortes Precisos Ltda.', num_contato: '(11) 2345-6789', cidade: 'São Paulo', estado: 'SP', entity_types_id: 2)
Entity.find_or_create_by(nome: 'Cortadores Unidos S.A.', num_contato: '(21) 6543-2109', cidade: 'Rio de Janeiro', estado: 'RJ', entity_types_id: 2)
Entity.find_or_create_by(nome: 'Cortes Expresso', num_contato: '(47) 1111-2222', cidade: 'Blumenau', estado: 'SC', entity_types_id: 2)
Entity.find_or_create_by(nome: 'Cortadores Mineiros Ltda.', num_contato: '(31) 8888-9999', cidade: 'Belo Horizonte', estado: 'MG', entity_types_id: 2)
Entity.find_or_create_by(nome: 'Cortes Eficientes', num_contato: '(54) 3333-4444', cidade: 'Caxias do Sul', estado: 'RS', entity_types_id: 2)

# Exemplos de entidades do tipo 'Costureira'
Entity.find_or_create_by(nome: 'Costuras Perfeitas Ltda.', num_contato: '(11) 9876-5432', cidade: 'São Paulo', estado: 'SP', entity_types_id: 3)
Entity.find_or_create_by(nome: 'Costureiras Criativas S.A.', num_contato: '(21) 5555-1234', cidade: 'Rio de Janeiro', estado: 'RJ', entity_types_id: 3)
Entity.find_or_create_by(nome: 'Costuras do Sul', num_contato: '(47) 7777-8888', cidade: 'Blumenau', estado: 'SC', entity_types_id: 3)
Entity.find_or_create_by(nome: 'Costureiras Mineiras Ltda.', num_contato: '(31) 4444-5555', cidade: 'Belo Horizonte', estado: 'MG', entity_types_id: 3)
Entity.find_or_create_by(nome: 'Costuras do Norte', num_contato: '(54) 2222-1111', cidade: 'Caxias do Sul', estado: 'RS', entity_types_id: 3)

# Exemplos de entidades do tipo 'Serigrafia'
Entity.find_or_create_by(nome: 'Arte Serigráfica Ltda.', num_contato: '(11) 7777-9999', cidade: 'São Paulo', estado: 'SP', entity_types_id: 4)
Entity.find_or_create_by(nome: 'Serigrafia Express S.A.', num_contato: '(21) 2222-1111', cidade: 'Rio de Janeiro', estado: 'RJ', entity_types_id: 4)
Entity.find_or_create_by(nome: 'Serigrafia Sulista', num_contato: '(47) 4444-5555', cidade: 'Blumenau', estado: 'SC', entity_types_id: 4)
Entity.find_or_create_by(nome: 'Arte em Serigrafia Ltda.', num_contato: '(31) 1111-2222', cidade: 'Belo Horizonte', estado: 'MG', entity_types_id: 4)
Entity.find_or_create_by(nome: 'Serigrafia Criativa', num_contato: '(54) 5555-4444', cidade: 'Caxias do Sul', estado: 'RS', entity_types_id: 4)

# Exemplos de entidades do tipo 'Acabamento'
Entity.find_or_create_by(nome: 'Acabamentos Elegantes Ltda.', num_contato: '(11) 8888-9999', cidade: 'São Paulo', estado: 'SP', entity_types_id: 5)
Entity.find_or_create_by(nome: 'Acabamento Fino S.A.', num_contato: '(21) 1111-2222', cidade: 'Rio de Janeiro', estado: 'RJ', entity_types_id: 5)
Entity.find_or_create_by(nome: 'Acabamentos Sulbrasileiros', num_contato: '(47) 5555-4444', cidade: 'Blumenau', estado: 'SC', entity_types_id: 5)
Entity.find_or_create_by(nome: 'Acabamentos Mineiros Ltda.', num_contato: '(31) 2222-3333', cidade: 'Belo Horizonte', estado: 'MG', entity_types_id: 5)
Entity.find_or_create_by(nome: 'Acabamentos do Norte', num_contato: '(54) 4444-5555', cidade: 'Caxias do Sul', estado: 'RS', entity_types_id: 5)

# Exemplos de entidades do tipo 'Vendedor' (continuação)
Entity.find_or_create_by(nome: 'Vendedores do Sul', num_contato: '(54) 6666-7777', cidade: 'Caxias do Sul', estado: 'RS', entity_types_id: 6)
Entity.find_or_create_by(nome: 'Vendas Inteligentes Ltda.', num_contato: '(11) 7777-8888', cidade: 'São Paulo', estado: 'SP', entity_types_id: 6)
Entity.find_or_create_by(nome: 'Vendedores Experientes S.A.', num_contato: '(21) 8888-9999', cidade: 'Rio de Janeiro', estado: 'RJ', entity_types_id: 6)
Entity.find_or_create_by(nome: 'Vendas Estratégicas', num_contato: '(47) 6666-5555', cidade: 'Blumenau', estado: 'SC', entity_types_id: 6)
Entity.find_or_create_by(nome: 'Vendedores Eficazes Ltda.', num_contato: '(31) 7777-6666', cidade: 'Belo Horizonte', estado: 'MG', entity_types_id: 6)
Entity.find_or_create_by(nome: 'Vendedores do Norte', num_contato: '(54) 5555-4444', cidade: 'Caxias do Sul', estado: 'RS', entity_types_id: 6)

# Exemplos de entidades do tipo 'Transportadora'
Entity.find_or_create_by(nome: 'TransLogística Expressa Ltda.', num_contato: '(11) 5555-8888', cidade: 'São Paulo', estado: 'SP', entity_types_id: 7)
Entity.find_or_create_by(nome: 'Transporte Rápido S.A.', num_contato: '(21) 4444-7777', cidade: 'Rio de Janeiro', estado: 'RJ', entity_types_id: 7)
Entity.find_or_create_by(nome: 'Transportadoras Unidos', num_contato: '(47) 3333-2222', cidade: 'Blumenau', estado: 'SC', entity_types_id: 7)
Entity.find_or_create_by(nome: 'Transporte Ágil Ltda.', num_contato: '(31) 6666-5555', cidade: 'Belo Horizonte', estado: 'MG', entity_types_id: 7)
Entity.find_or_create_by(nome: 'Transporte Seguro', num_contato: '(54) 2222-1111', cidade: 'Caxias do Sul', estado: 'RS', entity_types_id: 7)

# Usuário
admin = User.create(name: 'Lucas', password: '123456')
admin.user_permission = UserPermission.create(admin: true)