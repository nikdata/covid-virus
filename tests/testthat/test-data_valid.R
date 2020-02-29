test_that(desc = "Test the dates", {
  expect_equal(base::class(corona_virus$date) == "Date", TRUE)
  expect_equal(base::min(corona_virus$date) == as.Date("2020-01-22"), TRUE)
})

test_that(desc = "Test the type variable", {
  expect_equal(base::all(c("confirmed", "death", "recovered") %in%
                           unique(corona_virus$type)), TRUE)
  expect_equal(base::any(is.na(corona_virus$type)), FALSE)
})
