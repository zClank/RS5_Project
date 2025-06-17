# Redundância Tripla em Módulo de Execução do Processador RS5
🔗 Repositório: [https://github.com/zClank/RS5_Project](https://github.com/zClank/RS5_Project)

> Projeto desenvolvido como parte da disciplina **98G10-04 Confiabilidade e Segurança de Hardware** — PUCRS  
> Professor: Anderson Domingues

## Instruções de Execução

1. **Pré-requisitos**

   * Simulador utilizado: [QuestaSim (ModelSim)](https://eda.sw.siemens.com/en-US/ic/modelsim/)
   * Compilador RISC-V: `riscv64-elf-gcc`.
   * Para carregar os módulos necessários no terminal:

     ```bash
     module load questa
     module load riscv64-elf
     ```

2. **Compilação do programa de teste**
   Um código assembly simples foi desenvolvido para executar repetidas instruções de soma. Ele está localizado em:

   ```
   RS5_Project/
   └── app/
       └── assembly/
           ├── asm.s         # Código-fonte em assembly
           └── Makefile      # Script de compilação
   ```

   Para compilar:

   ```bash
   cd RS5_Project/app/assembly
   make
   ```

3. **Arquivos de simulação**
   O TestBench principal e o script de simulação estão localizados em:

   ```
   RS5_Project/
   └── sim/
       ├── testbench.sv
       └── sim.do
   ```

4. **Como executar**
   No terminal, dentro da pasta `RS5_Project/sim`:

   ```bash
   vsim -do sim.do
   ```

5. **Visualização dos resultados**

   * Durante a simulação, os resultados (como tempos de falha e valores dos componentes) são exibidos diretamente no console com comandos `$display`.
   * Após a execução, os dados podem ser consultados no arquivo `transcript`, gerado automaticamente pelo QuestaSim na mesma pasta.


### Itens atendidos

- [x] Código do processador adaptado com TMR (Triple Modular Redundancy)
- [x] Módulo árbitro implementado para tomada de decisão
- [x] TestBench com integração memória-processador
- [x] Programa com 5000 instruções de soma executado
- [x] Simulação realizada com coleta de falhas
- [x] Análise dos resultados com script em Python
- [x] Comparação com confiabilidade teórica documentada


## Estrutura do Projeto

A seguir está uma visão geral da organização do projeto, com foco nos componentes relacionados à simulação do processador RS5 com redundância tripla:

```
.
├── app/
│   └── assembly/               # Código-fonte do programa de teste em assembly
│       ├── asm.s               # Programa que executa somas em loop
│       └── Makefile            # Compila asm.s com riscv64-elf-gcc
│
├── rtl/                        # Módulos do processador e modificações
│   ├── execute_a.sv            # Versão com 99% de confiabilidade
│   ├── execute_b.sv            # Versão com 95% de confiabilidade
│   ├── execute_c.sv            # Versão com 90% de confiabilidade
│   ├── arbiter.sv              # Módulo árbitro para TMR (Triple Modular Redundancy)
│   └── [demais módulos].sv     # Demais componentes do processador
│
├── sim/                        # Ambiente de simulação com Questa
│   ├── testbench.sv            # TestBench integrando processador, memória e programa de teste
│   ├── RAM_mem.sv              # Implementação do módulo de memória
│   ├── sim.do                  # Script de automação da simulação
│   └── transcript              # Saída da simulação com logs dos $display
│
├── data_analysis/              # Análise dos resultados da simulação (Python)
│   ├── transcript.txt                          # Log bruto gerado pela simulação
│   ├── read_data.py                            # Script Python para leitura e processamento
│   ├── time_and_component_results.parquet      # Dados brutos estruturados
│   ├── time_and_component_results.xlsx         # Versão Excel dos dados brutos
│   ├── error_analysis.xlsx                     # Frequência de falhas por módulo
│   └── cumulative_sample_error_analysis.xlsx   # Análise incremental por amostra
│
└── README.md                   # Documentação do projeto (este arquivo)

```

## Resultados Obtidos

### Simulação de falhas

Para simular falhas nos módulos de execução redundantes, foi inserido um contador que adultera o resultado da operação de soma após um número fixo de execuções:

* `execute_a`: falha a cada 100 somas (simulando confiabilidade de 99%)
* `execute_b`: falha a cada 20 somas (95%)
* `execute_c`: falha a cada 10 somas (90%)

O valor inserido em caso de falha foi `0x12345678` (decimal: 305419896).

Durante a simulação, os valores resultantes de cada módulo foram registrados por meio do seguinte comando `$display`, incluído no módulo `arbiter.sv`:

```systemverilog
$display($time, ";", result_o, ";", result_a_i, ";", result_b_i, ";", result_c_i);
```

Esses dados foram salvos no arquivo `transcript` gerado pelo simulador.

### Processamento dos dados

O script `read_data.py`, localizado em `RS5_Project/data_analysis/`, foi utilizado para processar o arquivo `transcript`. Ele extrai os tempos de falha, identifica erros com base no valor fixo (`305419896`) e gera os seguintes arquivos:

```
RS5_Project/data_analysis/
├── time_and_component_results.parquet     # Dados convertidos em formato compacto
├── time_and_component_results.xlsx        # Versão tabular em Excel
├── error_analysis.xlsx                    # Frequência de falhas por módulo
├── cumulative_sample_error_analysis.xlsx  # Evolução das falhas por amostragem incremental
```

### Frequência de falhas (amostra de 5000 somas)

A tabela abaixo apresenta a proporção de falhas observadas em cada componente, bem como no valor final entregue pelo árbitro (`result_o`), dentro de uma amostra de 5000 operações:

| Sinal        | Proporção de falhas |
| ------------ | ------------------- |
| `result_o`   | 0,52%               |
| `result_a_i` | 0,92%               |
| `result_b_i` | 4,44%               |
| `result_c_i` | 8,52%               |

### Falhas completas do sistema

As falhas no sinal `result_o` representam os ciclos em que os três módulos apresentaram erro simultaneamente. Nesse conjunto de dados, foram identificadas 26 ocorrências desse tipo em 5000 operações.

### Cálculo analítico da confiabilidade

A confiabilidade teórica do sistema com redundância 1-de-3 (Triple Modular Redundancy) é dada pela probabilidade de pelo menos dois módulos operarem corretamente. Considerando falhas independentes, a probabilidade de falha do sistema é:

$$
P_{\text{falha}} = (1 - 0,99) \cdot (1 - 0,95) \cdot (1 - 0,90) = 0,00005
$$

Portanto, a confiabilidade esperada é:

$$
R_{\text{sistema}} = 1 - 0,00005 = 0,99995
$$

## Comparação entre simulação e análise teórica

Na simulação, considerando uma amostra de 5000 operações de soma, foi observada uma taxa de falha final (`result_o`) de aproximadamente 0,52%, equivalente a uma confiabilidade empírica de 99,48%.

A diferença entre o valor esperado teoricamente (99,995%) e o observado (99,48%) pode estar associada a diversos fatores, como:

* **Determinismo da falha**: as falhas foram introduzidas em intervalos fixos (ex: exatamente na operação de número 100), o que pode gerar padrões específicos de coincidência entre os módulos, diferente de um modelo probabilístico contínuo.
* **Tamanho da amostra**: a análise foi feita sobre um conjunto limitado de 5000 operações. Em modelos com eventos raros, pequenas amostras tendem a produzir variações mais significativas em relação ao valor teórico.
* **Sincronização entre módulos**: dependendo da implementação, os módulos `execute_a`, `b` e `c` podem chegar à condição de falha simultaneamente mais vezes do que o previsto teoricamente, devido ao alinhamento dos contadores internos.

Outras fontes potenciais de discrepância incluem o comportamento do árbitro, o alinhamento dos tempos de processamento e o próprio método de coleta e interpretação dos resultados.

## Informações adicionais

**Autores**:  
* André Lisboa
* Felipe Lacerda
* Lucas Azevedo
* Pedro Filippi
