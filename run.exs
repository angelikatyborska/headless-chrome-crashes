defmodule Run do
  use Wallaby.DSL

  import Wallaby.Query, only: [css: 1, css: 2]
  import Wallaby.Element, only: [attr: 2]

  def run do
    IO.inspect("visiting https://instagram.com/kimbramusic")
    {:ok, session} = Wallaby.start_session()

    links =
      session
      |> visit("https://instagram.com/kimbramusic")
      |> all(css("main article div div a"))


    IO.inspect("will visit #{links |> Enum.count()} pages")

    images =
      Enum.each(links, fn link ->
        {:ok, session2} = Wallaby.start_session()

        IO.inspect("visitng #{attr(link, "href")}")

        session2 = session2 |> visit(attr(link, "href"))
        imgs =
          session2
          |> all(css("article div div div div img"))


        image =
          if Enum.count(imgs) > 0 do
            [img | _] = imgs
            attr(img, "src")
          else
            [video | _] =
              session2
              |> all(css("article div div div div video"))

            attr(video, "poster")
          end

        Wallaby.end_session(session2) # without those, Chrome crashes

        image
      end)

    Wallaby.end_session(session) # without those, Chrome crashes

    images
  end
end

Run.run
