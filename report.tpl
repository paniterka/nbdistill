{%- extends 'basic.tpl' -%}
{% from 'mathjax.tpl' import mathjax %}

{%- block header -%}
  <!DOCTYPE html>
<html>
  <head>
    {%- block html_head -%}
      <script src="https://distill.pub/template.v2.js"></script>
      <meta name="viewport" content="width=device-width, initial-scale=1" >
      <meta charset="utf-8">

      <script src="https://cdnjs.cloudflare.com/ajax/libs/require.js/2.1.10/require.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>

      {% block ipywidgets %}
        {%- if "widgets" in nb.metadata -%}
          <script>
            (function() {
            function addWidgetsRenderer() {
            var mimeElement = document.querySelector('script[type="application/vnd.jupyter.widget-view+json"]');
            var scriptElement = document.createElement('script');
            var widgetRendererSrc = '{{ resources.ipywidgets_base_url }}@jupyter-widgets/html-manager@*/dist/embed-amd.js';
            var widgetState;
            // Fallback for older version:
            try {
            widgetState = mimeElement && JSON.parse(mimeElement.innerHTML);
            if (widgetState && (widgetState.version_major < 2 || !widgetState.version_major)) {
            widgetRendererSrc = '{{ resources.ipywidgets_base_url }}jupyter-js-widgets@*/dist/embed.js';
            }
            } catch(e) {}
            scriptElement.src = widgetRendererSrc;
            document.body.appendChild(scriptElement);
            }
            document.addEventListener('DOMContentLoaded', addWidgetsRenderer);
            }());
                                                            </script>
                                                          {%- endif -%}
                                                        {% endblock ipywidgets %}

                                                        <!-- Loading mathjax macro -->
          {{ mathjax() }}
        {%- endblock html_head -%}
  </head>
{%- endblock header -%}

{% block body %}
  {% set nb_authors = nb.metadata.get('authors', '') %}
  {% set nb_title = nb.metadata.get('title', '')  %}
  {% set nb_abstract = nb.metadata.get('abstract', '') %}
  <body>
    <d-front-matter>
      <script id="distill-front-matter" type="text/json">{
        "title": "{{ nb_title }}",
        "description": "{{ nb_abstract}}",
        "authors": {{ nb_authors | tojson | safe }}
        }
      </script>
    </d-front-matter>
    <d-title><p>{{ nb_abstract }}</p></d-title>
    <d-byline></d-byline>
    <d-article>
      {{ super() }}
    </d-article>
    <d-appendix>
      <d-bibliography src="refs.bib"></d-bibliography>
    </d-appendix>
  </body>
{%- endblock body %}

{% block input_group %}
  {% block in_prompt %}{% endblock in_prompt %}
  {% block input %}
    {% set cell_code = cell.metadata.get('code', 'python') %}
    {% if 'hide_code' not in cell.metadata.get('tags', []) %}
      <div class="cell border-box-sizing code_cell rendered">
        <d-code block language="{{ cell_code }}">
          {{ super() }}
        </d-code>
      </div>
    {% endif %}
  {% endblock input %}
{%- endblock input_group %}

{% block output_area_prompt%}
{% endblock output_area_prompt %}

{% block error -%}{%- endblock error %}
{% block stream_stdout -%}{%- endblock stream_stdout %}
{% block stream_stderr -%}{%- endblock stream_stderr %}

{% block execute_result -%}
  {{ super() }}
{%- endblock execute_result %}

{% block markdowncell scoped %}
  {% if 'only_md' in cell.metadata.get('tags', []) %}

    {% if 'margin' in cell.metadata.get('tags', []) %}
      <div class="l-gutter">
        {{ cell.source | markdown2html }}
      </div>
    {% else %}
      {{ cell.source | markdown2html }}
    {% endif %}

{% else %}

  {% if 'margin' in cell.metadata.get('tags', []) %}
    <div class="l-gutter">
      <p>
        {{ cell.source }}
      </p>
    </div>
  {% else %}
    <p>
      {{ cell.source }}
    </p>
  {% endif %}
{% endif %}
{%- endblock markdowncell %}


{% block data_png %}
  <figure>
    {{ super() }}
    {% if cell.metadata.caption %}
      <figcaption>{{ cell.metadata.caption }}</figcaption>
    {% endif %}
  </figure>
{% endblock data_png %}

{% block data_svg %}
  <figure>
    {{ super() }}
    {% if cell.metadata.caption %}
      <figcaption>{{ cell.metadata.caption }}</figcaption>
    {% endif %}
  </figure>
{% endblock data_svg %}

{% block footer %}
  {{ super() }}
</html>
{% endblock footer %}
