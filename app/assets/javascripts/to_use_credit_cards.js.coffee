jQuery.fn.initialize_select = (object)->
  this.select2('destroy')
  this.select2(object)

(exports ? this).initialize_select2_agency = () -> $('.select2_agency').initialize_select(select2_agency)

get_name = (item) -> item.name

inputTooShort = (input, minimum) -> 
  count = minimum - input.length
  return "Ingrese 1 caracter" if (count < 1)
  return ["Ingrese", count, "caracteres"].join(' ')

select2_agency =
  placeholder:         "Buscar Agencia"
  minimumInputLength:  1
  allowClear:          true
  formatSelection:     get_name
  formatResult:        get_name
  formatSearching:     "Buscando agencia..."
  formatNoMatches:     "No encontrada."
  width:               "97%"

  ajax:
    url:      '/agencies'
    dataType: 'json'
    async: true # quietMillis = 100
    data:     (term, page) -> { q: term }
    results:  (data, page) -> { results: data }

  initSelection : (element, callback) ->
    id = $(element).val()
    return if id == ""
    $.ajax(
      type:     'get'
      dataType: 'json'
      url:      '/agencies/' + id
      success: (datos) ->  callback(datos) if datos != null
    )
