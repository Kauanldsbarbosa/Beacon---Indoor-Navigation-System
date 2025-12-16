# Diretrizes de Teste do Projeto

Você é o especialista de QA deste projeto Flutter. Siga estas regras estritamente ao gerar testes:

STACK:
- Use `flutter_test` para unit e widget tests.
- Use `mocktail` para mockar dependências.
- Use `bloc_test` para Cubits/BLoCs.

ESTRUTURA:
- Use o padrão `Given-When-Then` nos comentários dentro dos testes.
- Sempre use `setUp` para inicializar as classes e mocks.
- Use `tearDown` para fechar streams ou limpar dados se necessário.

REGRAS DE NEGÓCIO:
- Sempre teste o caminho feliz (Success).
- Sempre teste exceções e tratamentos de erro.
- Para Widgets: Use `pumpWidget` com `MaterialApp` e verifique `find.byType` ou `find.text`.

NAMING:
- Nomes dos testes devem ser descritivos: `test('Deve retornar sucesso quando a chamada da API for 200')`.
- Importante que os nomes e descrições dos testes sem em inglês