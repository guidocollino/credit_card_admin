Tabulous.setup do

  tabs do

    to_use_credit_cards_tab do
      text          { "Para usar" }
      link_path     { to_use_credit_cards_path }
      visible_when  { true }
      enabled_when  { true }
      active_when   { in_action('index').of_controller('to_use_credit_cards') }
    end

    # taked_credit_cards_tab do
    #   text          { 'Tomadas' }
    #   link_path     { taked_credit_cards_to_use_credit_cards_path }
    #   visible_when  { true }
    #   enabled_when  { true }
    #   active_when   { in_action('taked_credit_cards').of_controller('to_use_credit_cards') }
    # end

    used_credit_cards_tab do
      text          { 'Usos' }
      link_path     { used_credit_cards_to_use_credit_cards_path }
      visible_when  { true }
      enabled_when  { true }
      active_when   { in_action('used_credit_cards').of_controller('to_use_credit_cards') }
    end

    disabled_credit_cards_tab do
      text          { 'Deshabilitadas' }
      link_path     { disabled_credit_cards_to_use_credit_cards_path }
      visible_when  { true }
      enabled_when  { true }
      active_when   { in_action('disabled_credit_cards').of_controller('to_use_credit_cards') }
    end

  end

  customize do

    # which class to use to generate HTML
    # :default, :html5, :bootstrap, :bootstrap_pill or :bootstrap_navbar
    # or create your own renderer class and reference it here
    # renderer :default

    # whether to allow the active tab to be clicked
    # defaults to true
    # active_tab_clickable true

    # what to do when there is no active tab for the current controller action
    # :render -- draw the tabset, even though no tab is active
    # :do_not_render -- do not draw the tabset
    # :raise_error -- raise an error
    # defaults to :do_not_render
    # when_action_has_no_tab :do_not_render

    # whether to always add the HTML markup for subtabs, even if empty
    # defaults to false
    # render_subtabs_when_empty false
    renderer :bootstrap                      # generate Twitter Bootstrap-style HTML for tabs
    active_tab_clickable = false             # don't allow the selected tab to be clicked
    when_action_has_no_tab = :raise_error    # error out if there is no selected tab
    render_subtabs_when_empty = true         # always include subtab markup, even if empty

  end

  # The following will insert some CSS straight into your HTML so that you
  # can quickly prototype an app with halfway-decent looking tabs.
  #
  # This scaffolding should be turned off and replaced by your own custom
  # CSS before using tabulous in production.
  use_css_scaffolding do
    background_color '#ccc'
    text_color '#444'
    active_tab_color '#fff'
    hover_tab_color '#ddd'
    inactive_tab_color '#aaa'
    inactive_text_color '#888'
  end

end
