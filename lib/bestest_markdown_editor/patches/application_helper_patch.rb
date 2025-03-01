require_dependency 'application_helper'

module InstanceMethods
	def preview_link_with_js_function(url, form, target='preview', options={})
		preview_link_without_js_function(url, form, target, options) +
		javascript_tag(%%
			bestest_markdown_editor.preview["#{escape_javascript form}"] = function(plainText, preview) {
			$.ajax({
				url:     "#{escape_javascript url_for(url)}",
				type:    "post",
				global:  false,
				data:    $("##{escape_javascript form}").serialize(),
				success: function(data) { preview.innerHTML = data; }
			});
		};%)
	end
end

module BestestMarkdownEditor
    module Patches
        module ApplicationHelperPatch
            def self.included(base) # :nodoc:
                base.send(:include, InstanceMethods)
                base.class_eval do
                    unloadable
                    prepend InstanceMethods
                end
            end   
        end
    end
end

unless ApplicationHelper.included_modules.include? BestestMarkdownEditor::Patches::ApplicationHelperPatch
    ApplicationHelper.send(:include, BestestMarkdownEditor::Patches::ApplicationHelperPatch)
end
