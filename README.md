# Customizações no NovoSGA

Este repositório documenta ajustes realizados no **NovoSGA** com foco em **usabilidade** e **modo Totem (autoatendimento)**.

---

## 1. Ocultar elementos administrativos e de navegação, deixando apenas a seleção de serviços visível.

---

### Elementos ocultados

* `#infobar` → Campo de documento e nome do cliente
* `.d-flex` → Título da página e botões (Consultar senha, Agendamentos, Configuração)
* `header` → Cabeçalho padrão do sistema (menu superior)

---

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


## 2. Exibir **o nome do paciente no tooltip**, quando disponível, mantendo compatibilidade com o comportamento atual.



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
  
E não interferem no fluxo padrão administrativo do NovoSGA.


-Para ultilizar
Crie uma pasta /novosga dentro de /html/vendor, copie os arquivos desse diretorio
No docker-compose.yml adicione o volume

services:
  novosga:
    image: novosga/novosga:2.2-standalone
    volumes:
      - ./html/vendor/novosga/triage-bundle:/var/www/html/vendor/novosga/triage-bundle
      - ./html/vendor/novosga/attendance-bundle:/var/www/html/vendor/novosga/attendance-bundle

Caso não suba as modificações:
Depois do novosga ser instalado

Execute: docker exec -it <nome_do_container> bin/console cache:clear
Execute: docker exec -it <nome_do_container> bin/console assets:install

