defmodule Lynx.Accounts do
  use Ash.Domain

  resources do
    resource Lynx.Accounts.AnonymousUser
    resource Lynx.Accounts.Token
    resource Lynx.Accounts.User
  end
end
