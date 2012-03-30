# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def tab_for(text, link)
  	content_tag :li, link_to(text, link, :class => ("selected" if @current_section.titleize == text))
  end
  
  def google_analytics_include_js
' <script type="text/javascript">
  var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
  document.write(unescape("%3Cscript src=\'" + gaJsHost + "google-analytics.com/ga.js\' type=\'text/javascript\'3E%3C/script%3E"));
</script>'
  end
  
  def google_analytics_call_js
' <script type="text/javascript">
  try{
    var pageTracker = _gat._getTracker("UA-432142-4");
    pageTracker._trackPageview();
  } catch(err) {}
</script>'
  end
end
