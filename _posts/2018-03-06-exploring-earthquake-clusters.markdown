---
layout: post
title: Exploring Earthquake Clusters with Python
date: 2018-03-06
categories: visualization programming python
---

I'm currently traveling around Taiwan.
Right before I landed in Taipei, I saw reports of a swarm of earthquakes hitting
the Hualien area and was concerned about traveling in that region.
I did a bit of digging into Taiwan's open earthquake reports to find out if or when it was safe to travel to that area again.

### Getting Data

Taiwan's earthquake data is available on Taiwan's
[Central Weather Bureau site](https://www.cwb.gov.tw/V7e/earthquake/seismic.htm)
by month via HTML tables. I used the 
[Selenium Python package](https://seleniumhq.github.io/selenium/docs/api/py/index.html) 
to get January, February, and March's tables, then used [Beautiful Soup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/),
an XML parsing library, to extract data from the HTML tables.

```python
# function to extract earthquake data from HTML table row
def find_earthquakes(soup):
    earthquakes = []
    for tr in soup.find_all("tr")[1::]:
        content = tr.find_all("a")
        if len(content) > 1:
            ts = arrow.get(content[1].text, tzinfo="+0800")
            lon = float(content[2].text)
            lat = float(content[3].text)
            mag = float(content[4].text)
            desc = content[6].text
            earthquakes.append([ts, lon, lat, mag, desc[1::]])
    return earthquakes

# Get earthquake data for Jan, Feb, March
select_months = ["1", "2", "3"]
all_earthquakes = []

driver = webdriver.PhantomJS()
driver.get("https://scweb.cwb.gov.tw/Page.aspx?ItemId=26&loc=en&gis=n")

for month in select_months:
    # Find the "select" element that lets us choose a month
    select = Select(driver.find_element_by_id("ctl03_ddlMonth"))
    select.select_by_visible_text(month)

    # Choose a month, click the button, and load the month's data
    sbtn = driver.find_element_by_id("ctl03_btnSearch")
    sbtn.click()

    # Parse the HTML table using BeautifulSoup
    soup = BeautifulSoup(driver.page_source, "html5lib")
    all_earthquakes += find_earthquakes(soup)
```

We just turned HTML pages into a Python list. Now we can start visualizing!

### Visualizing

My goal was to see if it was safe in Taiwan and see if strong earthquakes were still happening.
I decided to plot earthquakes using a scatterplot, with the X axis representing time of
occurrence and Y axis representing magnitude.
While I usually use matplotlib for visualization in Python, I wanted to try out
[Bokeh](https://bokeh.pydata.org/en/latest/), which provides interactive chart elements
out of the box.

![The chart]({{site.url}}/assets/img/posts/2018-03-07-exploring-earthquake-clusters/earthquakes-taiwan.png)

Here's the code used to generate the scatterplot.

```python
import bokeh
from bokeh.plotting import figure, show
from bokeh.models import Title, ColumnDataSource, HoverTool

x = list(map(lambda z: z[0].datetime, all_earthquakes))
y = list(map(lambda z: z[3], all_earthquakes))
desc = list(map(lambda z: z[4], all_earthquakes))

ds = ColumnDataSource({
    "x": x,
    "y": y,
    "desc": desc
})

hover = HoverTool(tooltips=[
        ("location", "@desc"),
        ("mag", "@y")
    ])

fig = figure(title="Earthquakes in Taiwan, Jan - March 2018", x_axis_type='datetime',
             plot_width=900, plot_height=300, tools=[hover])
fig.add_layout(Title(text="source: http://www.cwb.gov.tw/V7e/earthquake/seismic.htm", align="center"), "below")

fig.yaxis.axis_label = "Magnitude"
fig.xaxis.axis_label = "Date"

fig.circle("x", "y", source=ds, size=3, color="steelblue", alpha=0.7)

show(p)
```

Some things to note:

#### ColumnDataSource

`ColumnDataSource` is a data structure used by Bokeh that maps names to sequences (Python lists, numpy arrays, Pandas series).
In this case, we called our "x" and "y" data `x` and `y`, respectively, and we also added another column called `desc`
that is used for our tooltips (the `HoverTool` object).
This data structure keeps all of the attributes to our data in one place.

#### Tooltips

Tooltip functionality is built into Bokeh, and it's one of my favorite things about this library.
I can format what my tooltips will look like by creating a `HoverTool` object and passing it
to my figure.
Check out [the HoverTool documentation](https://bokeh.pydata.org/en/latest/docs/user_guide/tools.html#hovertool)
to learn more about tooltip formatting.

#### p.circle

Rather than pass our `ColumnDataSource` directly to a `scatterplot` function, we call Bokeh's
[circle](https://bokeh.pydata.org/en/latest/docs/user_guide/plotting.html) method and pass in our
`ColumnDataSource` with the column names of our x and y values.
Bokeh comes with other shapes, like `square`, `diamond`, `cross`, and so on.
This is handy if we want to plot different certain values with different shapes and colors.

### Thoughts

It turns out the
[earthquake swarm](https://news.nationalgeographic.com/2018/02/earthquake-swarm-taiwan-experts-disagree-spd/)
ended right before I landed.
Earthquakes aren't easy to predict for scientists who are much more educated about this topic than I am.
I wasn't expecting to predict the next large earthquake, but I wanted visualize the frequency of earthquakes to get a better understanding of the trend of their occurrences.

I ended up visiting Hualien county for a few days during the lantern festival and saw that many others were unconcerned about the earthquakes.
Gathering and visualizing all this data took me a relatively short amount of time to do,
$and it felt satisfying to answer my own question using open source visualization tools I've used before.

I have this notebook up on
[GitHub](https://github.com/joannecheng/notebooks/blob/master/earthquake_notebook/taiwan-earthquakes.ipynb)
and encourage you to play with it yourself.
What kind of questions can you answer using these tools?
