module CapitalizeHelper
  def capitalize_and_remove_undescore(string)
    string.capitalize.sub('_', ' ')
  end
end
