module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Travel Crumbs"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def countries
    [
      ['',''],
      ['Argentina'],
      ['Australia'],
      ['Austria'],
      ['Bolivia'],
      ['Brazil'],
      ['Canada'],
      ['Chile'],
      ['China'],
      ['Croatia'],
      ['Denmark'],
      ['Ecuador'],
      ['France'],
      ['Germany'],
      ['Indonesia'],
      ['Japan'],
      ['Laos'],
      ['Norway'],
      ['Peru'],
      ['Spain'],
      ['Sweden'],
      ['Thailand'],
      ['UK'],
      ['USA'],
      ['Vietnam']
    ]
  end
  
end
