module ActionView
  module Helpers
    module FormTagHelper
      
      def submit_tag(value = "Save changes", options = {})
        options.stringify_keys!

        if mobile?
          options.delete('disable_with') unless supports_javascript?
        end
          
        if disable_with = options.delete("disable_with")
          disable_with = "this.value='#{disable_with}'"
          disable_with << ";#{options.delete('onclick')}" if options['onclick']
          
          options["onclick"]  = "if (window.hiddenCommit) { window.hiddenCommit.setAttribute('value', this.value); }"
          options["onclick"] << "else { hiddenCommit = this.cloneNode(false);hiddenCommit.setAttribute('type', 'hidden');this.form.appendChild(hiddenCommit); }"
          options["onclick"] << "this.setAttribute('originalValue', this.value);this.disabled = true;#{disable_with};"
          options["onclick"] << "result = (this.form.onsubmit ? (this.form.onsubmit() ? this.form.submit() : false) : this.form.submit());"
          options["onclick"] << "if (result == false) { this.value = this.getAttribute('originalValue');this.disabled = false; }return result;"
        end

        if confirm = options.delete("confirm")
          options["onclick"] ||= ''
          options["onclick"] << "return #{confirm_javascript_function(confirm)};"
        end

        tag :input, { "type" => "submit", "name" => "commit", "value" => value }.update(options.stringify_keys)
      end
      
    end
  end
end