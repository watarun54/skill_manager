module PapersHelper
  def truncate_paper_title(title, num)
    title = title.try(:truncate, 50)
    if title.nil?
      ""
    else
      arr = title.scan(/.{1,#{num}}/)
      simple_format(arr.join('<br>'))
    end
  end
end
