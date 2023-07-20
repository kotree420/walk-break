class WithLineBreakValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # ビューのformでの改行コードとRailsでの改行コードの文字数の違いに対応する
    current_text_length = value&.gsub(/\r\n/, "\n")&.length
    record.errors.add(attribute, "#{options[:maximum]}文字以内で入力してください") if current_text_length > options[:maximum]
  end
end
