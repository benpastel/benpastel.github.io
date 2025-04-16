---
layout: post
title: A Philosophy of Code Review
---
I used to review code by hunting for flaws, and suggesting how to fix them.  Then I'd block the PR until I reviewed the fixes.

I was proud of my code reviews because I caught bugs and offered solid improvements.  But for reasons I didn't really understand, I kept triggering defensive reactions, and people avoided tagging me as a reviewer.

This is how I learned what an effective review culture feels like, and a few ideas on how to get there.  If you don't care for the story, jump to my arguments at [Comment for Understanding](#1-comment-for-understanding), [Block Sparingly](#2-block-sparingly), [Talk Early](#3-talk-early).

## Before
A while ago, I reviewed a junior engineer adding a new search endpoint with limit and offset parameters.  I hunted for a bug: is the result ordering consistent?  Ah, the query has no ORDER BY.  Flag the bug and suggest a fix: "You need an ORDER BY here so the limit+offset is consistent."  Block until changed.

The junior engineer argued with me in the comments.  "The query performs a linear scan in the on-disk order, so it's not a bug!  And anyway this endpoint is for an internal analytics query that's urgent, but not going to stick around."   I argued back.  "The ordering could change if the query or indices changed in the future, and you never know what's going to stick around and get called in a different context in the future, so please fix it."  They stopped arguing and changed it, and I finally approved the PR.

This exchange stuck in my memory because it _offended_ me.  Sometimes my comments are wrong.  More often if I'm arguing in a comment thread, I'm partially misunderstanding something, or the author and I disagree on priority.  But in this case I was proud to find a pretty clear bug, and the fix was easy.  Why did they get defensive?  Did my comment need sugarcoating?  Or a more persuasive argument?  I wish I could say I learned something, but it's hard to learn when you're offended.

My actual learning happened from experiencing a really good culture, and then losing it.

## A Good Feeling
For over four years, I worked on a stable team of three.   Working with the same two productive and likeable coworkers for so long, we gradually built a deep trust and expectation of quick, thoughtful reviews.

As an author, it's _JUST SO NICE_ to put up a PR, see it approved the next day with thoughtful comments, and then use your professional judgement to triage those comments, merge, and move on with your job.  It's motivating; you want to put up the next PR faster.  And when you're grateful for receiving fast and thoughtful reviews, it feels important to reciprocate.

High trust has downsides: it's tempting to skim.  A gnarly diff while the reviewer is particularly busy often got a cursory look with apology.  And it's easy for documentation to slip, because there's so much shared understanding.

But overall this environment pushed us into a rhythm of small, readable PRs every few days.  I was the most productive I've been in my life.  I believed we'd discovered The Right Way to code review.

This continued until we made a new hire, and trust fell apart pretty quickly.  Reviewing one of his PRs, I hammered a critique that he felt was unrelated to his diff and patronizing; then he blocked one of my PRs on a documentation issue that I felt was unrelated and low-priority.  We avoided tagging each other as reviewers for a while.   Until _eventually_ we came to our senses and talked through feelings in a call.  Our working relationship somewhat recovered... but it never felt good.

This drove home that we hadn't really solved code review.  We had reached effectiveness by circumstance of working together on a small, stable team for so long, and outside of that context I hadn't learned much.

So how do you build a good environment without working on an unchanging team for 4 years?  Well, I haven't yet, but here's what I'll try next time.

## (Table Stakes) Linting & Autoformat
Move anything you can out of review and into CI.

For years, I wasted a lot of energy commenting "please add type annotations to this function header so I can understand what the arguments mean", when it only took a day of work to automatically enforce that rule in the linter for all new projects.

## (1) Comment for Understanding
The reviewer, by default, starts out not understanding the change.  As you read, you gain partial understanding.

It's really annoying to have your work critiqued by someone who only partially understands it!  I believe this feeling of being _unfairly judged_ is the core of what makes people defensive.

As a reviewer you _could_ combat this by reading the whole diff and trying to hold it all in your mind before your first comment.  But that's exhausting.  Besides, readability is the author's responsibility.  Your main goal should be to _help them make their code easier to understand_.  Making code understandable is as effective at squashing bugs as straight up searching for bugs.

So, as a reviewer, it's better to _embrace_ partial understanding, and use it to drive comments.  Look for a reading sequence that starts at some abstraction, like a new API endpoint, or new type, or a function header.  What's unclear about the behavior inside that abstraction?  Resist the urge to read ahead; instead, try to articulate your confusion at that snapshot in time.

You don't want an explanation just in the PR thread, because it's lost to future maintainers.  Instead, suggest they change the code or docs to resolve the ambiguity.  "From this function header I'm not sure what you'll output when there are duplicates in the list; can you explain in the docstring?  If you're assuming there aren't any, maybe change the parameter to a set?"

## (2) Block Sparingly
It's natural to block the review to see how they address your comments.

But I often see even strong engineers block without considering the cost of another round of review.  The author can't merge before starting their next change, forcing them to juggle more open branches and face gatekeeping frustration.  If they _expect_ blockage, they avoid submitting incremental changes and instead drop a massive PR when the feature is complete. Massive PRs demand longer reviews, reinforcing a negative cycle.

Of course, sometimes, it's still worth blocking.  If you requested complicated changes that really need a second look, or a production bug would be really damaging, or the author is too junior to be trusted.  I'm just saying to weigh these tangible benefits against the intangible costs each time.

## (3) Talk Early
This one is obvious but hard for me.  If you're going back and forth in a comment thread, there's probably a misunderstanding or a philosophical disagreement.  Either way, you learn more on a call than through asynchronous written arguments, because it's easier to learn their feelings when you see their face.

It's common to agree that Good Things Are Good (testing, docs, comments) but disagree on prioritization.  So part of building trust is learning what your coworkers care _most_ about and why, and explaining what you care _most_ about and why.

## After
Back to the original limit+offset example.

I _wish_ I had read the endpoint documentation first and paused before examining the query.  "From this description I don't understand what order the results will be in, which matters for the limit+offset.  Can you explain in the docstring?"  Later I'd see the actual query, and add a follow up.  "How about an explicit ORDER BY here to match whatever the documented ordering is?"  Simple, low-risk fix; approve with comments.

With this approach, I'm 95% confident they would have fixed it without pushback.  I'm not saying they messed up; I'm saying I didn't understand, so could the code please clear up my confusion?  If they ignore _that_ request, well, maybe there's some critical triage context they forgot to explain ("we need this up for a demo ASAP!").  Or maybe we disagree how much analytics accuracy matters and should talk it through face to face.  In any case, the risk is small and it's not worth damaging trust _just in case_.

What do you think?  I'm curious for other takes but, uh, too lazy to implement comments on this blog.  So I guess write a response and post it to Hacker News :)
