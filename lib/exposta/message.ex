defmodule ExPosta.Message do

  alias ExPosta.Message

  @from_email Application.get_env(:exposta, :from_email)
  @reply_to_email Application.get_env(:exposta, :reply_to_email)

  defstruct(
    from:         @from_email,
    to:           [],
    cc:           [],
    bcc:          [],
    subject:      "",
    tag:          "",
    html:         "",
    text:         "",
    reply_to:     @reply_to_email,
    headers:      [],
    track_opens:  true,
    attachments:  []
  )

  def new(text \\ "", opts \\ []) do
    msg = %Message{ "text": text }
    Keyword.take(opts, Map.keys(msg))
    |> Map.new
    |> Map.merge(msg, fn _,v,_ -> v end)
  end
end

defimpl Poison.Encoder, for: ExPosta.Message do

  alias Poison.Encoder
  alias ExPosta.Message

  def encode(msg=%Message{}, options) do
    Encoder.encode(%{
      "From"        => msg.from,
      "To"          => Enum.join(msg.to, ","),
      "Cc"          => Enum.join(msg.cc, ","),
      "Bcc"         => Enum.join(msg.bcc, ","),
      "Subject"     => msg.subject,
      "Tag"         => msg.tag,
      "HtmlBody"    => msg.html,
      "TextBody"    => msg.text,
      "Reply_to"    => msg.reply_to,
      "Headers"     => msg.headers,
      "TrackOpen"   => msg.track_opens,
      "Attachments" => msg.attachments
    }, options)
  end
end
