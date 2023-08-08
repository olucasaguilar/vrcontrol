# EntityType (Malharia, Cortador, Costureira, Serigrafia, Acabamento, Vendedor, Transportadora)
# abaixo, cria os tipos de entidades
EntityType.find_or_create_by(nome: 'Malharia')
EntityType.find_or_create_by(nome: 'Cortador')
EntityType.find_or_create_by(nome: 'Costureira')
EntityType.find_or_create_by(nome: 'Serigrafia')
EntityType.find_or_create_by(nome: 'Acabamento')
EntityType.find_or_create_by(nome: 'Vendedor')
EntityType.find_or_create_by(nome: 'Transportadora')

# abaixo, cria as entidades
Entity.find_or_create_by(nome: 'Malharia Tal 1', num_contato: '11 99999-9999', cidade: 'São Paulo', estado: 'SP', entity_types_id: 1)
Entity.find_or_create_by(nome: 'Malharia Tal 2', num_contato: '43 99999-9999', cidade: 'Londrina', estado: 'PR', entity_types_id: 3)
Entity.find_or_create_by(nome: 'Malharia Tal 3', num_contato: '11 99999-9999', cidade: 'São Paulo', estado: 'SP', entity_types_id: 7)
Entity.find_or_create_by(nome: 'Confecções Modernas', num_contato: '21 98765-4321', cidade: 'Rio de Janeiro', estado: 'RJ', entity_types_id: 1)
Entity.find_or_create_by(nome: 'Fashion Styles Ltda.', num_contato: '31 91234-5678', cidade: 'Belo Horizonte', estado: 'MG', entity_types_id: 1)