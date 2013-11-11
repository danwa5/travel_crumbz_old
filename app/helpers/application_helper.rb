module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Travel Crumbz"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def date_ordinal_format(date)
    unless date.blank?
      #date.strftime("%B %-d, %Y")
      date.to_formatted_s(:long_ordinal)
    end
  end

  def date_short_format(date)
    unless date.blank?
      date.strftime("%m/%d/%Y")
    end
  end

  ###################
  #  Field Options  #
  ###################

  def tiles
    [2, 4, 6, 8, 9]
  end

  def sort_key
    [
      ['Travel date','start_date'],
      ['Entry post date','created_at'],
      ['Likes count','likes']
    ]
  end

  def sort_order
    [
      ['Ascending','ASC'],
      ['Descending','DESC']
    ]
  end

  def countries
    [
      [''],
      ['Argentina'],
      ['Australia'],
      ['Austria'],
      ['Bolivia'],
      ['Brazil'],
      ['Canada'],
      ['Chile'],
      ['China'],
      ['Croatia'],
      ['Czech Republic'],
      ['Denmark'],
      ['Ecuador'],
      ['France'],
      ['Germany'],
      ['Hungary'],
      ['Indonesia'],
      ['Italy'],
      ['Japan'],
      ['Laos'],
      ['Malaysia'],
      ['Norway'],
      ['Peru'],
      ['Slovenia'],
      ['Spain'],
      ['Sweden'],
      ['Thailand'],
      ['UK'],
      ['USA'],
      ['Vietnam']
    ]
  end
  
end
