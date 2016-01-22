# http://stackoverflow.com/questions/1509915/converting-camel-case-to-underscore-case-in-ruby
# Allow us to convert CamelCase => camel_case
class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end
