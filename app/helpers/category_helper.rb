module CategoryHelper
  def veg_or_both_category
    (session[:category].eql? 'veg') || (session[:category].eql? 'both')
  end

  def non_veg_or_both_category
    (session[:category].eql? 'non_veg') || (session[:category].eql? 'both')
  end
end
