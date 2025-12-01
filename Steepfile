# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  # チェック対象のRubyファイル
  check "lib"

  # 型シグネチャファイルの場所
  signature "sig"

  # 利用する標準ライブラリのシグネチャ
  # Ruby 3.1以降の標準ライブラリ
  library "date"
  library "pathname"

  # 設定
  configure_code_diagnostics(D::Ruby.strict)
end
