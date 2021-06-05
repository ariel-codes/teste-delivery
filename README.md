# Teste de Dev Backend usando Ruby!
ariel.santos@dcc.ufmg.br

## Variáveis de ambiente / Serviços
- `DATABASE_URL`: url de conexão a um BD MongoDB
- `DELIVERY_CENTER_API_URL`: url da API REST para POST

### Como rodar
`bin/thin -R config.ru -a 127.0.0.1 -p 8080 start`

### Como testar
`bin/rspec`

## Descrição do projeto

O objetivo deste teste é avaliar a organização do seu código, e como você estrutura uma solução simples e eficiente baseada em requisitos simples.

### Caso

O Delivery Center está em plena expansão de suas operações pelo Brasil, com planos audaciosos de operar nas maiores capitais ainda em 2019.
Um dos passos dessa expansão é ampliar a captação de pedidos de diversos canais, sejam eles de `food`, `goods`, `FMCG`, `services`, entre outros.
O mais recente movimento para alcançar este objetivo é a integração a um dos maiores marketplaces do país. Esta integração permitirá captar pedidos dos nossos lojistas que operam neste canal
e operá-los em nossa estrutura logística, entregando pedidos em `same hour / same day`.

Para viabilizar esta integração, um dos passos importantes é realizar o `parsing` dos dados que vêm da API deste canal para a nossa estrutura, garantindo que
a nossa operação irá receber de forma correta e clara as informações necessárias para entregar o pedido na casa do cliente, no endereço correto, para o cliente correto,
com clareza dos valores a serem pagos, formas de pagamento, entre outras informações.

Vale ressaltar que sem as informações corretas a operação do Delivery Center pode ter prejuízos no envio, gerando custos extras de envio e insatisfação do cliente.

### Informações Complementares
O `JSON` a seguir representa um payload com dados fictícios de um pedido de compra de alguns produtos por um cliente.

  - Utilizar a linguagem Ruby, mas pode escolher qualquer framework / libs (gems) que quiser para auxiliar no desenvolvimento, como, por exemplo: Rails, Sinatra, Padrino, etc. Se preferir, pode não usar nenhum. Essa escolha não irá influenciar na avaliação.
  - Fazer um parse do **Payload** abaixo.
  - Enviar para uma API REST (https://delivery-center-recruitment-ap.herokuapp.com/), no formato descrito no item **Processamento**, que fará algumas validações e retornará o resultado.
  - Enviar com o Header 'X-Sent' com a data/hora atual no formato: 09h25 - 24/10/19.
  - Registrar os dados do pedido em um banco de dados
      - Nesse caso você deve também incluir no seu código o schema do banco de dados (se utilizar Rails, o arquivo `schema.rb` é suficiente).
  - Deixar o código disponível em algum repositório público (github,  bitbucket, etc...)
  - :warning: Manter seu código limpo (Clean Code = :heart:), seguindo as convenções da comunidade
  - :warning: Escrever testes automatizados. Você pode usar qualquer framework de testes que conheça (exemplo: rspec, MiniTest, TestUnit, etc)
  - Enviar o link do repositório para o e-mail **testes.tech@deliverycenter.com**

### Payload
```json
{
  "id": 9987071,
  "store_id": 282,
  "date_created": "2019-06-24T16:45:32.000-04:00",
  "date_closed": "2019-06-24T16:45:35.000-04:00",
  "last_updated": "2019-06-25T13:26:49.000-04:00",
  "total_amount": 49.9,
  "total_shipping": 5.14,
  "total_amount_with_shipping": 55.04,
  "paid_amount": 55.04,
  "expiration_date": "2019-07-22T16:45:35.000-04:00",
  "total_shipping": 5.14,
  "order_items": [
    {
      "item": {
        "id": "IT4801901403",
        "title": "Produto de Testes"
      },
      "quantity": 1,
      "unit_price": 49.9,
      "full_unit_price": 49.9
    }
  ],
  "payments": [
    {
      "id": 12312313,
      "order_id": 9987071,
      "payer_id": 414138,
      "installments": 1,
      "payment_type": "credit_card",
      "status": "paid",
      "transaction_amount": 49.9,
      "taxes_amount": 0,
      "shipping_cost": 5.14,
      "total_paid_amount": 55.04,
      "installment_amount": 55.04,
      "date_approved": "2019-06-24T16:45:35.000-04:00",
      "date_created": "2019-06-24T16:45:33.000-04:00"
    }
  ],
  "shipping": {
    "id": 43444211797,
    "shipment_type": "shipping",
    "date_created": "2019-06-24T16:45:33.000-04:00",
    "receiver_address": {
      "id": 1051695306,
      "address_line": "Rua Fake de Testes 3454",
      "street_name": "Rua Fake de Testes",
      "street_number": "3454",
      "comment": "teste",
      "zip_code": "85045020",
      "city": {
        "name": "Cidade de Testes"
      },
      "state": {
        "name": "São Paulo"
      },
      "country": {
        "id": "BR",
        "name": "Brasil"
      },
      "neighborhood": {
        "id": null,
        "name": "Vila de Testes"
      },
      "latitude": -23.629037,
      "longitude": -46.712689,
      "receiver_phone": "41999999999"
    }
  },
  "status": "paid",
  "buyer": {
    "id": 136226073,
    "nickname": "JOHN DOE",
    "email": "john@doe.com",
    "phone": {
      "area_code": 41,
      "number": "999999999"
    },
    "first_name": "John",
    "last_name": "Doe",
    "billing_info": {
      "doc_type": "CPF",
      "doc_number": "09487965477"
    }
  }
}
```

### Processamento

Abaixo um exemplo do payload esperado, casando com os dados informados no payload acima.

  - **Todos os campos são obrigatórios**:
  - Caso ocorra algum erro, os mesmos deverão ser tratados.
  - Não é necessário o desenvolvimento de uma interface gráfica.

```JSON
{
    "externalCode": "9987071",
    "storeId": 282,
    "subTotal": "49.90",
    "deliveryFee": "5.14",
    "total_shipping": 5.14,
    "total": "61.90",
    "country": "BR",
    "state": "SP",
    "city": "Cidade de Testes",
    "district": "Bairro Fake",
    "street": "Rua de Testes Fake",
    "complement": "galpao",
    "latitude": -23.629037,
    "longitude":  -46.712689,
    "dtOrderCreate": "2019-06-27T19:59:08.251Z",
    "postalCode": "85045020",
    "number": "0",
    "customer": {
        "externalCode": "136226073",
        "name": "JOHN DOE",
        "email": "john@doe.com",
        "contact": "41999999999"
    },
    "items": [
        {
            "externalCode": "IT4801901403",
            "name": "Produto de Testes",
            "price": 49.9,
            "quantity": 1,
            "total": 49.9,
            "subItems": []
        }
    ],
    "payments": [
        {
            "type": "CREDIT_CARD",
            "value": 55.04
        }
    ]
}
```
