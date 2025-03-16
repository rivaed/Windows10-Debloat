```markdown
# Windows 10 Debloat Script

## Descrição

Este script remove aplicativos desnecessários, desativa serviços inúteis e ajusta configurações para melhorar o desempenho do Windows 10. Ideal para usuários que desejam um sistema mais limpo, leve e rápido.

## Funcionalidades

- Remoção de bloatwares (aplicativos pré-instalados).
- Desativação da telemetria e coleta de dados.
- Otimização de serviços e processos.
- Ajustes no sistema para melhor performance.

## Como Usar

### Método 1: Baixando e Executando o Script

1. **Baixe o script `debloat-windows10.ps1`.**
2. **Abra o PowerShell como Administrador.**
3. **Habilite a execução de scripts** (caso necessário):
   ```powershell
   Set-ExecutionPolicy Unrestricted -Scope CurrentUser
   ```
4. **Navegue até o diretório onde o script foi salvo:**
   ```powershell
   cd C:\caminho\para\o\script
   ```
5. **Execute o script:**
   ```powershell
   .\debloat-windows10.ps1
   ```

### Método 2: Execução via Comando Único (Recomendado)

Abra o **PowerShell como Administrador** e execute:
```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/rivaed/Windows10-Debloat/main/debloat-windows10.ps1'))
```

## Aviso

Este script altera configurações do sistema e remove aplicativos. **Use por sua conta e risco.** Recomenda-se criar um ponto de restauração antes da execução para evitar problemas caso algo não ocorra como esperado.

## Contribuições

Contribuições são bem-vindas! Se você deseja sugerir melhorias ou adicionar novas funcionalidades, sinta-se à vontade para abrir uma *issue* ou enviar um *pull request*.

## Licença

Este projeto está licenciado sob a **MIT License** – sinta-se livre para modificar e compartilhar.
```
