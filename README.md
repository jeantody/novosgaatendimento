# Customizações no NovoSGA

Este repositório documenta ajustes realizados no **NovoSGA** com foco em **usabilidade** e **modo Totem (autoatendimento)**.

---

## 1. Modo Totem na Triagem (ocultação de elementos)

### Módulo

* **Triage (Triagem)**

### Contexto

Para uso em **totem de autoatendimento**, alguns elementos da interface padrão não são necessários e atrapalham a experiência do usuário final.

### Objetivo

Ocultar elementos administrativos e de navegação, deixando apenas a seleção de serviços visível.

---

### Elementos ocultados

* `#infobar` → Campo de documento e nome do cliente
* `.d-flex` → Título da página e botões (Consultar senha, Agendamentos, Configuração)
* `header` → Cabeçalho padrão do sistema (menu superior)

---

### Arquivo alterado

Template de triagem:

```twig
{% extends "@NovosgaTriage/base.html.twig" %}
```

---

### Implementação

Adicionar o CSS **logo após** o início do `{% block body %}`:

```twig
{% block body %}
    <style>
        /* Oculta a barra de informações do cliente */
        #infobar,
        /* Oculta o topo com título e botões */
        .d-flex,
        /* Oculta o cabeçalho padrão do layout */
        header {
            display: none !important;
        }
    </style>
```

---

### Explicação técnica

* O CSS é aplicado localmente no template, sem afetar outras telas.
* `!important` garante precedência sobre estilos do Bootstrap.
* Não há impacto em backend ou JavaScript.

---

### Resultado

Interface limpa, ideal para **autoatendimento em totem**, exibindo apenas os serviços disponíveis ao público.

---

## 2. Tooltip com nome do paciente na fila de atendimento

### Módulo

* **Attendance (Fila de Atendimento)**

### Contexto

Nas filas (ex.: **Todos serviços**, **Serviço teste**), era exibido apenas:

* A senha (ex.: `A006`)
* Tooltip com:

  ```
  Serviço (Tempo de Espera)
  ```

### Objetivo

Exibir **o nome do paciente no tooltip**, quando disponível, mantendo compatibilidade com o comportamento atual.

---

### Arquivo alterado

```
vendor/novosga/attendance-bundle/
└── src/Resources/views/default/index.html.twig
```

---

### Alteração realizada

#### Antes

```twig
v-bind:title="atendimento.servico.nome + ' (' + atendimento.tempoEspera + ')'"
```

#### Depois

```twig
v-bind:title="(atendimento.cliente ? atendimento.cliente.nome + ' - ' : '') 
              + atendimento.servico.nome + ' (' + atendimento.tempoEspera + ')'"
```

---

### Lógica aplicada

* Se existir paciente:

  ```
  Nome do Paciente - Serviço (Tempo de Espera)
  ```
* Se não existir:

  ```
  Serviço (Tempo de Espera)
  ```

Fallback garantido. Nenhuma quebra.

---

### Origem dos dados

* `atendimento.cliente.nome` já é enviado via AJAX
* Confirmado em:

  ```
  src/Entity/AbstractAtendimento.php
  ```

  (`cliente` incluído no `jsonSerialize()`)

---

### Impacto

* ✔ Melhoria de usabilidade
* ✔ Nenhuma alteração em backend ou API
* ✔ Aplica-se a todas as filas (`fila.atendimentos`)
* ✔ Sem impacto em performance

---

## Rollback

* **Modo Totem**: remover o bloco `<style>` do template de triagem
* **Tooltip**: restaurar o `v-bind:title` original no arquivo Twig

---

## Observação final

Essas customizações são ideais para:

* Ambientes de alto fluxo
* Totens de autoatendimento
* Clínicas, laboratórios e unidades com triagem pública

E não interferem no fluxo padrão administrativo do NovoSGA.

No docker-compose.yml adicione o volume

services:
  novosga:
    image: novosga/novosga:2.2-standalone
    volumes:

      - ./html/vendor/novosga:/var/www/html/vendor/novosga

-Depois do novosga ser instalado

Execute :docker exec -it <nome_do_container> bin/console cache:clear

Execute: docker exec -it <nome_do_container> bin/console assets:install

