# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

def tab_for(text, link)
	content_tag :li, link_to(text, link, :class => ("selected" if @current_section.titleize == text))
end

end
