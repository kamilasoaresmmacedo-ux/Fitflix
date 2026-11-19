# NextFit

NextFit é um aplicativo Flutter multiplataforma para alunos de academia, com foco em treinos, acompanhamento de progresso e hábitos saudáveis.

## MVP

- **Início:** visão da semana, próximo treino e hábitos do dia.
- **Treino:** lista de exercícios, marcação de exercícios concluídos e controle de início/fim da sessão.
- **Progresso:** resumo de frequência, gráfico semanal e atividade recente.
- **Hábitos:** acompanhamento diário de hidratação, sono e alongamento.

Os dados do MVP são exemplos locais e as interações permanecem em memória durante a sessão. Não há conta, sincronização ou recursos de gestão da academia.

## Executar

As pastas nativas Android e iOS já estão incluídas. Use Flutter 3.50 ou superior:

```sh
flutter pub get
flutter run
```

O build Android requer Android SDK. Compilar e executar no iPhone requer macOS com Xcode.

Para validar os testes do app:

```sh
flutter test
```
