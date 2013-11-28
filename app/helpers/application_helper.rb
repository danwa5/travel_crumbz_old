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

  def valid_month(month)
    if month.blank?
      return false
    else
      if month.to_i.between?(1,12)
        return true
      else
        return false
      end
    end
  end

  def valid_year(year)
    if year.blank?
      return false
    else
      if year.to_i.between?(1900,2013)
        return true
      else
        return false
      end
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

  def month_names
    {
      '1' => 'January',
      '2' => 'February',
      '3' => 'March',
      '4' => 'April',
      '5' => 'May',
      '6' => 'June',
      '7' => 'July',
      '8' => 'August',
      '9' => 'September',
      '10' => 'October',
      '11' => 'November',
      '12' => 'December'
    }
  end

  def countries
    [
      [''],
      ['Antarctica'],
      ['Argentina'],
      ['Australia'],
      ['Austria'],
      ['Bolivia'],
      ['Brazil'],
      ['Cambodia'],
      ['Canada'],
      ['Chile'],
      ['China'],
      ['Colombia'],
      ['Croatia'],
      ['Cuba'],
      ['Czech Republic'],
      ['Denmark'],
      ['Ecuador'],
      ['Finland'],
      ['France'],
      ['Germany'],
      ['Greece'],
      ['Hungary'],
      ['India'],
      ['Indonesia'],
      ['Iraq'],
      ['Italy'],
      ['Jamaica'],
      ['Japan'],
      ['Laos'],
      ['Malaysia'],
      ['New Zealand'],
      ['Norway'],
      ['Paraguay'],
      ['Peru'],
      ['Philippines'],
      ['Portugal'],
      ['Russia'],
      ['Slovenia'],
      ['South Korea'],
      ['Spain'],
      ['Sweden'],
      ['Switzerland'],
      ['Thailand'],
      ['UK'],
      ['Uruguay'],
      ['USA'],
      ['Vietnam']
    ]
  end
  
end
