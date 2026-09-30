# Pokédex Dio

Um aplicativo Flutter simples e elegante que consome a [PokéAPI](https://pokeapi.co/) para exibir a lista dos 151 Pokémon da primeira geração e seus detalhes. Este projeto foi desenvolvido com foco em boas práticas de consumo de API usando o pacote `dio`.

## 📱 Demonstração

O aplicativo possui duas telas principais:
1. **Lista de Pokémon:** Exibe os primeiros 151 Pokémon com seus respectivos números na Pokédex.
2. **Detalhes do Pokémon:** Exibe a arte oficial do Pokémon, juntamente com informações vitais como Altura e Peso.

## ✨ Funcionalidades

*   Listagem dos 151 Pokémon originais (Geração 1).
*   Navegação para a tela de detalhes de cada Pokémon.
*   Exibição de imagem (Official Artwork), altura (em metros) e peso (em kg).
*   Tratamento de estados na UI (Carregamento, Erro e Sucesso).
*   Botão de "Tentar Novamente" em caso de falha de conexão ou servidor.

## 🛠️ Tecnologias e Pacotes Utilizados

*   **[Flutter](https://flutter.dev/):** Framework de UI do Google.
*   **[Dart](https://dart.dev/):** Linguagem de programação.
*   **[Dio](https://pub.dev/packages/dio):** Poderoso cliente HTTP para Dart, usado para realizar as requisições à PokéAPI.

## 📂 Estrutura do Projeto

A organização dos arquivos segue uma arquitetura baseada em features/camadas simples:

```text
lib/
├── models/
│   ├── pokemon.dart           # Modelo para os itens da lista
│   └── pokemon_details.dart   # Modelo detalhado (peso, altura, imagem)
├── screens/
│   ├── pokemon_list_screen.dart    # Tela principal com a lista
│   └── pokemon_details_screen.dart # Tela de detalhes do Pokémon
├── services/
│   └── pokemon_api.dart       # Classe responsável pelas requisições via Dio
├── app.dart                   # Configuração principal do MaterialApp
└── main.dart                  # Ponto de entrada da aplicação
```

## 🚀 Como Executar o Projeto

### Pré-requisitos
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.
*   Um emulador configurado ou dispositivo físico conectado.

### Passos

1. **Clone o repositório** (ou copie os arquivos para um novo projeto Flutter).
2. **Navegue até a pasta do projeto:**
   ```bash
   cd seu_repositorio
   ```
3. **Instale as dependências:**
   ```bash
   flutter pub get
   ```
   *(Certifique-se de que o pacote `dio` está declarado no seu `pubspec.yaml`)*
4. **Execute o aplicativo:**
   ```bash
   flutter run
   ```

## 🌐 API Utilizada

Este projeto utiliza a [PokéAPI (v2)](https://pokeapi.co/).
*   **Endpoint de Lista:** `https://pokeapi.co/api/v2/pokemon?limit=151`
*   **Endpoint de Detalhes:** `https://pokeapi.co/api/v2/pokemon/{id}/`