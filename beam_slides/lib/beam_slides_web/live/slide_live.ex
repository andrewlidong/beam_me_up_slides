defmodule BeamSlidesWeb.SlideLive do
  use BeamSlidesWeb, :live_view

  @slides [
    %{
      id: 1,
      title: "BEAM and Elixir",
      content: "Building a Modern Messaging App",
      style: "title-slide",
      notes: "Welcome to this presentation about BEAM and Elixir! This talk will explain why BEAM is perfect for building modern messaging applications."
    },

    %{
      id: 2,
      title: "Introduction to the BEAM VM",
      content: "The BEAM is the Erlang Virtual Machine – a runtime originally built by Ericsson in the 1980s for telecom systems.",
      bullets: [
        "Designed for massive concurrency",
        "Built for fault tolerance",
        "Operates in soft real-time conditions"
      ],
      notes: "BEAM stands for Bogdan/Björn's Erlang Abstract Machine. Key point: it was built for telephone switches which had to stay up 24/7 with 'carrier-grade' reliability."
    },

    %{
      id: 3,
      title: "Why is BEAM special?",
      content: "BEAM was \"born for\" highly available, distributed systems (think phone switches, messaging servers).",
      notes: "Emphasize that BEAM's design goals match perfectly with today's needs for scalable, resilient services like chat apps, messaging platforms, and real-time features."
    },

    %{
      id: 4,
      title: "Lightweight processes & concurrency",
      content: "Uses the actor model – lightweight isolated processes instead of OS threads.",
      bullets: [
        "BEAM can spawn millions of processes with minimal overhead",
        "Each process has its own tiny heap (just a few KB)",
        "Processes run independently, enabling massive concurrency"
      ],
      notes: "Compare to OS threads which are much heavier (~1MB vs a few KB). Mention that WhatsApp handled 2M+ connections per server. Each user connection can be its own process!"
    },

    %{
      id: 5,
      title: "Asynchronous message passing",
      content: "BEAM processes do not share memory; they communicate by sending messages.",
      bullets: [
        "Isolation by design prevents bugs from corrupting other processes",
        "All interactions are lock-free and thread-safe",
        "Simplifies concurrency for developers"
      ],
      notes: "This is different from the shared-memory concurrency model in most languages. No need for locks, mutexes, or semaphores in most code. Message passing is explicit and clear."
    },

    %{
      id: 6,
      title: "Preemptive scheduling",
      content: "Soft real-time capabilities for responsive applications.",
      bullets: [
        "VM scheduler automatically time-slices processes",
        "No single process can hog the CPU – BEAM preempts tasks",
        "Garbage collection is per-process, avoiding system-wide pauses",
        "Consistent low-latency responses for chat, gaming, etc."
      ],
      notes: "Most VMs (like JVM) might pause everything for GC. BEAM only pauses individual processes, keeping the system responsive. Great for chat apps where delays are frustrating for users."
    },

    %{
      id: 7,
      title: "Built-in fault tolerance",
      content: "BEAM was designed with a \"let it crash\" philosophy.",
      bullets: [
        "Developers let processes fail rather than writing defensive code everywhere",
        "Supervisors (monitoring processes) restart failed processes",
        "Systems self-heal and maintain high uptime"
      ],
      notes: "This is a radically different philosophy from most languages. Instead of trying to handle every error, we embrace failure and design systems that recover automatically."
    },

    %{
      id: 8,
      title: "Proven in the real world",
      content: "These aren't just theoretical benefits - BEAM powers critical systems.",
      bullets: [
        "WhatsApp: 2 million concurrent connections on a single server",
        "Discord: Millions of realtime messages with high reliability",
        "Ericsson: Telecom systems with \"nine nines\" (99.9999999%) uptime"
      ],
      notes: "WhatsApp scaled to serve 900 million users with only 50 engineers thanks to BEAM. Discord handles 5+ million concurrent users. Emphasize these are real benefits not just theoretical."
    },

    %{
      id: 9,
      title: "How BEAM's Concurrency Works",
      content: "A deeper look at what makes BEAM's concurrency model unique",
      style: "title-slide",
      notes: "Now we'll dive deeper into the specific technical aspects of how BEAM implements its concurrency model."
    },

    %{
      id: 10,
      title: "Lightweight Processes",
      content: "BEAM processes are extremely lightweight user-space threads.",
      bullets: [
        "Creating a process takes just microseconds",
        "Initial memory footprint is only ~300 words (~2-4 KB)",
        "Spawn hundreds of thousands or millions on a single machine",
        "Much lighter than OS threads (which use megabytes each)"
      ],
      notes: "A key comparison point: OS threads might use 1-2MB each and are limited to thousands on a system. BEAM processes are so cheap you can create one per user connection, one per transaction, or even one per message."
    },

    %{
      id: 11,
      title: "Process Isolation",
      content: "Each process has its own memory space with no shared state.",
      bullets: [
        "Every process has its own stack and heap",
        "No shared mutable state by default",
        "Process crashes are contained and don't affect others",
        "Makes debugging and reasoning about code much easier"
      ],
      notes: "This isolation is fundamental to BEAM's reliability. Explain how in other systems, a crash in one part (like one user's request) might corrupt memory used by other parts of the application."
    },

    %{
      id: 12,
      title: "Message Passing",
      content: "Processes communicate by sending asynchronous messages.",
      bullets: [
        "The VM handles copying messages between processes",
        "No locks or shared resources to manage",
        "Makes concurrent code easier to reason about",
        "Like having tiny isolated microservices within your app"
      ],
      notes: "Use a chat example: A user process sends a message to a room process, which then sends copies to all recipient processes. No shared memory means no race conditions or deadlocks."
    },

    %{
      id: 13,
      title: "Preemptive Scheduling",
      content: "The BEAM scheduler ensures all processes get fair CPU time.",
      bullets: [
        "One scheduler thread per CPU core",
        "Processes get small time slices (milliseconds)",
        "CPU-heavy tasks can't starve other processes",
        "System stays responsive even under heavy load"
      ],
      notes: "This is what makes BEAM 'soft real-time'. While it doesn't guarantee exact timing (hard real-time), it ensures consistent responsiveness. Even if one user is uploading a huge file, others can still chat without lag."
    },

    %{
      id: 14,
      title: "Scalability",
      content: "BEAM's concurrency model scales with available hardware.",
      bullets: [
        "Run queue per CPU core for optimal distribution",
        "Near-linear scaling with additional cores",
        "Transparent distribution across multiple nodes",
        "Message passing works the same across nodes as within a node"
      ],
      notes: "This is crucial for growing applications. Start with one server, then scale to multiple nodes - the same code works without changes. The distribution is transparent to application code."
    },

    %{
      id: 15,
      title: "Fault Tolerance and \"Let It Crash\"",
      content: "Building systems that recover from failures automatically",
      style: "title-slide",
      notes: "Now we'll explore BEAM's approach to handling errors and building resilient systems. This philosophy is what sets BEAM apart from most other platforms."
    },

    %{
      id: 16,
      title: "The \"Let It Crash\" Philosophy",
      content: "A different approach to error handling.",
      bullets: [
        "Traditional: Defensively handle every possible error",
        "BEAM/OTP: Assume things will go wrong and design for recovery",
        "Focus on writing the \"happy path\" code, simplifying development",
        "Trust the runtime to handle failures gracefully"
      ],
      notes: "This is counterintuitive for many developers coming from other languages. Instead of writing complex error handling everywhere, we write simpler code that focuses on the 'normal' path, and let the system handle the crashes."
    },

    %{
      id: 17,
      title: "Supervision Trees",
      content: "A hierarchical structure of processes for automatic recovery.",
      bullets: [
        "Supervisor processes watch over worker processes",
        "Each supervisor has a restart strategy (one-for-one, one-for-all, etc.)",
        "Automatically restarts crashed child processes",
        "Can be nested to create complex recovery strategies"
      ],
      notes: "Use the chat room example: A supervisor manages all chat room processes. If one room crashes while processing a message, the supervisor spawns a new room process in milliseconds. Users might experience a brief hiccup but the system keeps running."
    },

    %{
      id: 18,
      title: "Fault-Tolerant by Design",
      content: "Isolation and supervision create inherent resilience.",
      bullets: [
        "Process isolation prevents errors from cascading",
        "Failures are contained to specific components",
        "System keeps running even when parts fail",
        "Deploy new features without fear of bringing everything down"
      ],
      notes: "This is like having circuit breakers in an electrical system - one component fails but everything else keeps running. It gives developers confidence to ship changes more frequently. Errors are expected and managed, not catastrophic events."
    },

    %{
      id: 19,
      title: "Soft State and Recovery",
      content: "Building self-healing systems with in-memory state.",
      bullets: [
        "BEAM systems often keep state in memory (inside processes)",
        "Supervision can recover even in-memory state",
        "Processes can monitor each other using links and monitors",
        "Death notifications enable cooperative cleanup and recovery"
      ],
      notes: "For example, if a user session process crashes, the supervision strategy might restart it. The user might need to log in again, but the overall system remains up. This makes building self-healing systems much more straightforward than in traditional platforms."
    },

    %{
      id: 20,
      title: "Real-World Uptime",
      content: "Why BEAM systems are known for reliability.",
      bullets: [
        "Telecom switches achieve \"nine 9s\" (99.9999999%) reliability",
        "Systems that recover so quickly users rarely notice failures",
        "Automatically restart processes at 3am without paging developers",
        "Chat servers that stay online 24/7 despite unexpected issues"
      ],
      notes: "This isn't just theoretical - real systems have proven this approach works. Erlang-powered telecom systems have famously run for years without downtime, even while being upgraded. For a messaging app, this means services that handle disruptions gracefully without human intervention."
    },

    %{
      id: 21,
      title: "Elixir – A Friendly Face on the BEAM",
      content: "Modern syntax meets battle-tested infrastructure",
      style: "title-slide",
      notes: "Now we'll explore Elixir, which brings a more approachable syntax and modern tooling to the BEAM platform. Elixir makes BEAM's powerful capabilities more accessible to today's developers."
    },

    %{
      id: 22,
      title: "What is Elixir?",
      content: "A modern programming language built on top of the BEAM VM.",
      bullets: [
        "Created in 2012 by José Valim (Ruby core contributor)",
        "Clean, Ruby-inspired syntax with functional programming",
        "Compiles to the same bytecode as Erlang",
        "Built to leverage all of BEAM's power with improved developer experience"
      ],
      notes: "José Valim created Elixir when he was looking for a language that could better utilize multicore processors. He was a Ruby developer who loved Ruby's expressiveness but needed the concurrency capabilities of Erlang/BEAM."
    },

    %{
      id: 23,
      title: "Erlang Compatibility",
      content: "Elixir seamlessly interoperates with Erlang's ecosystem.",
      bullets: [
        "Can call Erlang libraries and functions directly",
        "Uses the OTP framework for concurrency and supervision",
        "Inherits 30+ years of battle-tested technology",
        "Gets all BEAM superpowers (processes, distribution, fault tolerance)"
      ],
      notes: "This is a key advantage - Elixir doesn't reinvent the wheel. It builds on Erlang's proven technology while making it more approachable. All Erlang libraries are immediately available to Elixir developers without wrappers or bridges."
    },

    %{
      id: 24,
      title: "Approachability & Productivity",
      content: "Developer-friendly features that enhance productivity.",
      bullets: [
        "Concise and expressive Ruby-like syntax",
        "Interactive REPL (IEx) with excellent helpers",
        "Friendly error messages and debugging tools",
        "Excellent documentation and guides",
        "Functional programming with immutability and pattern matching"
      ],
      notes: "Elixir was specifically designed to be approachable for developers coming from languages like Ruby, Python, or JavaScript. The functional nature helps prevent many common bugs related to state management, while the tooling helps developers be productive quickly."
    },

    %{
      id: 25,
      title: "Phoenix Web Framework",
      content: "A powerful, productive framework for web applications.",
      bullets: [
        "To Elixir what Rails is to Ruby",
        "Built specifically to leverage BEAM's strengths",
        "Excellent for real-time features and high concurrency",
        "Includes LiveView for interactive UIs with minimal JavaScript",
        "Used by Discord, Pinterest, and other high-scale services"
      ],
      notes: "Phoenix was created by Chris McCord and has become the go-to framework for web development in Elixir. It's particularly strong for applications that need real-time features, like chat, dashboards, or collaborative tools."
    },

    %{
      id: 26,
      title: "Elixir Summary",
      content: "\"Modern syntax, ancient power\"",
      bullets: [
        "Friendly gateway to BEAM's incredible capabilities",
        "Combines the best of both worlds: readability and reliability",
        "Perfect for systems that need to scale and never go down",
        "Especially well-suited for modern messaging applications",
        "Growing community with quality libraries and tools"
      ],
      notes: "With the basics of BEAM and Elixir in mind, we can see why this combination is so powerful for building modern messaging apps. We get the concurrency and reliability of BEAM with the developer-friendly approach of Elixir."
    },

    %{
      id: 27,
      title: "BEAM Powers for a Modern Messaging App",
      content: "Applying BEAM's strengths to build real-time chat applications",
      style: "title-slide",
      notes: "Now we'll look at concrete examples of how BEAM and Elixir are perfectly suited for building modern messaging applications. We'll examine specific features and how they leverage BEAM's strengths."
    },

    %{
      id: 28,
      title: "Real-Time Chat (Concurrency in Action)",
      content: "Let's see how BEAM's concurrency model shines in a messaging app.",
      bullets: [
        "Each user connection gets its own lightweight process",
        "Message broadcasting leverages BEAM's message passing",
        "Fault isolation prevents one user's issues from affecting others",
        "Built-in scaling as user numbers grow"
      ],
      notes: "This section demonstrates how the theoretical benefits we've discussed translate into practical advantages for building a messaging app. We'll focus on Phoenix's real-time capabilities which are built on BEAM's strengths."
    },

    %{
      id: 29,
      title: "Many Users, Many Connections",
      content: "Supporting massive concurrent connections is straightforward on BEAM.",
      bullets: [
        "Every WebSocket connection backed by a dedicated BEAM process",
        "Handle tens of thousands of simultaneous users with ease",
        "Phoenix leverages this to make real-time connections simple",
        "Each connection isolated, preventing cascading failures"
      ],
      notes: "On other platforms, supporting thousands of WebSocket connections can be challenging, requiring complex thread pools or async I/O. In Phoenix, it's the default architecture because of BEAM's lightweight processes."
    },

    %{
      id: 30,
      title: "Phoenix Channels",
      content: "Real-time communication made simple with Phoenix Channels.",
      bullets: [
        "Built on BEAM's message passing capabilities",
        "Topic-based PubSub for efficient message routing",
        "Push messages to all subscribers instantly",
        "Basic chat room in ~50 lines of Elixir code"
      ],
      code: "MyAppWeb.Endpoint.broadcast(\"room:lobby\", \"new_msg\", %{body: message})",
      notes: "Phoenix Channels abstract away the complexity of real-time messaging. The code example shows how simple it is to broadcast a message to everyone in a chat room. Under the hood, this leverages BEAM processes and message passing."
    },

    %{
      id: 31,
      title: "Phoenix LiveView",
      content: "Real-time UI updates without JavaScript.",
      bullets: [
        "Server-rendered UI that updates in real-time",
        "Each LiveView backed by a BEAM process",
        "Efficient updates via DOM diffing and patching",
        "Perfect for chat interfaces, notifications, live feeds"
      ],
      notes: "LiveView is an optional but powerful tool that further simplifies building real-time interfaces. It uses the same BEAM process model but adds automatic UI synchronization. For a chat app, this means you can build interactive features with minimal frontend code."
    },

    %{
      id: 32,
      title: "Scaling Real-Time Features",
      content: "Phoenix's PubSub is cluster-aware for horizontal scaling.",
      bullets: [
        "Messages propagate across all nodes in a cluster",
        "Add more servers as user count grows",
        "Handle millions of subscribers on distributed systems",
        "The same code works from prototype to production scale"
      ],
      notes: "This is where BEAM's distributed capabilities shine. Unlike many platforms where scaling requires architectural changes, Phoenix apps can scale horizontally with minimal changes. The PubSub system automatically handles node-to-node communication."
    },

    %{
      id: 33,
      title: "Example – Broadcasting",
      content: "Global announcements to all connected users.",
      bullets: [
        "Simple one-line broadcast to all connected clients",
        "No manual thread management",
        "No locks or synchronization needed",
        "Efficient fan-out to thousands of connections"
      ],
      code: "broadcast(socket, \"announcement\", %{body: \"Hello world\"})",
      notes: "This example shows how simple it is to send a message to every connected user. BEAM's concurrency model makes this efficient even with thousands of recipients. This is exactly the kind of workload BEAM was built for in telecom systems."
    },

    %{
      id: 34,
      title: "Language Translation (Async External Calls)",
      content: "Handling slow external services without blocking",
      style: "title-slide",
      notes: "Let's look at another practical example: implementing a language translation feature in our chat app. This showcases how BEAM handles I/O-bound operations that need to call external services."
    },

    %{
      id: 35,
      title: "Feature Idea: Real-time Message Translation",
      content: "Translate messages into each user's preferred language on the fly.",
      bullets: [
        "Users can see messages in their own language",
        "Requires calling external translation APIs",
        "Translation calls are slow (tens to hundreds of ms)",
        "Must not block the main messaging flow"
      ],
      notes: "This is a real-world feature that demonstrates BEAM's power. Translation APIs are typically slow and unpredictable - the exact kind of I/O-bound operation that can cause problems in many platforms."
    },

    %{
      id: 36,
      title: "Non-blocking by Design",
      content: "BEAM's process model makes async operations straightforward.",
      bullets: [
        "Spawn separate processes for translation calls",
        "Each translation request runs in isolation",
        "Main system continues handling chat messages",
        "No single slow API call blocks the entire app"
      ],
      notes: "In traditional platforms, you might block a thread, use complex callback chains, or need to manage thread pools. In BEAM, you just spawn lightweight processes - the VM handles scheduling efficiently."
    },

    %{
      id: 37,
      title: "Using Tasks for Async Jobs",
      content: "Elixir provides simple abstractions for async work.",
      bullets: [
        "Task module makes spawning async jobs easy",
        "Each translation runs in its own process",
        "Results sent as messages when complete",
        "Main process continues without waiting"
      ],
      code: "Task.start(fn -> \n  translated = Translator.translate(msg.text, to: user_pref_language)\n  send(self(), {:translated_msg, translated})\nend)",
      notes: "This code example shows how straightforward it is to handle async operations. The translation happens in a separate process, and when it's done, it sends a message back to the originating process. No callbacks or promises needed."
    },

    %{
      id: 38,
      title: "Throughput and Scalability",
      content: "Isolated processes ensure system stability.",
      bullets: [
        "Translation failures don't affect other operations",
        "Slow API calls only delay individual translations",
        "Can supervise tasks for automatic retry",
        "Users without translation see no performance impact"
      ],
      notes: "This isolation is crucial for reliability. If the translation service is having problems, only the translation feature is affected - the core chat functionality remains responsive. You can even set up supervisors to automatically retry failed translations."
    },

    %{
      id: 39,
      title: "Integration with HTTP Libraries",
      content: "Elixir HTTP clients leverage BEAM's concurrency.",
      bullets: [
        "Libraries like Finch or HTTPoison built for async work",
        "Network I/O handled by BEAM's async threads",
        "Processes yield control while waiting for responses",
        "Simple, straight-line code instead of callbacks"
      ],
      notes: "BEAM's approach to I/O is particularly elegant. When a process makes a network request, it yields control until the response arrives. The scheduler puts it to sleep and runs other processes in the meantime. When the response comes back, the process is woken up."
    },

    %{
      id: 40,
      title: "Example Scenario",
      content: "100 users in a channel, each with different language preferences.",
      bullets: [
        "New English message arrives in the chat",
        "Spawn up to 100 translation tasks simultaneously",
        "BEAM handles all these concurrent processes with ease",
        "Each user receives their translated version when ready"
      ],
      notes: "This would be challenging in many platforms. In Node.js, you'd worry about blocking the event loop. In threaded languages, spawning 100 OS threads would be heavy. In BEAM, 100 processes is nothing - it can handle millions. This is why BEAM excels at this kind of workload."
    },

    %{
      id: 41,
      title: "End-to-End Encryption (Security in Elixir)",
      content: "Building secure communication in your messaging app",
      style: "title-slide",
      notes: "Now we'll explore how BEAM and Elixir can support security features like end-to-end encryption for a messaging application."
    },

    %{
      id: 42,
      title: "Why End-to-End Encryption?",
      content: "Privacy by design in modern messaging apps.",
      bullets: [
        "Messages encrypted on sender's device",
        "Only decrypted by intended recipient's device",
        "Server cannot read message contents",
        "Essential for privacy-focused messaging"
      ],
      notes: "E2EE has become the standard for modern chat applications like Signal, WhatsApp, and others. Users increasingly expect their private communications to be secure from all third parties, including the service provider."
    },

    %{
      id: 43,
      title: "Elixir's Cryptography Tools",
      content: "Built-in libraries for implementing encryption.",
      bullets: [
        "Erlang's :crypto module built on OpenSSL",
        "Access to encryption primitives like AES, RSA",
        "Additional libraries available through Hex packages",
        "No need to write C code for most crypto operations"
      ],
      code: ":crypto.crypto_one_time(:aes_256_cbc, key, iv, plaintext, encrypt: true)",
      notes: "The BEAM platform provides strong cryptographic functionality out of the box. While you wouldn't implement your own crypto algorithms, you have all the tools needed to incorporate standard encryption protocols into your application."
    },

    %{
      id: 44,
      title: "Implementing E2EE",
      content: "Approaches to end-to-end encryption in an Elixir app.",
      bullets: [
        "Client-side encryption/decryption with server as relay",
        "Server-assisted key exchange (e.g., Diffie-Hellman)",
        "Ephemeral key pairs for perfect forward secrecy",
        "Per-user processes can handle encryption contexts"
      ],
      notes: "True E2EE would do the encryption and decryption on the client side, with the server just relaying encrypted messages. However, the server can still facilitate key exchange or handle certain security operations without compromising the E2E nature."
    },

    %{
      id: 45,
      title: "Process per User for Security",
      content: "BEAM's process model enhances security isolation.",
      bullets: [
        "Each user gets their own process with encryption context",
        "Process isolation prevents key material leakage",
        "RSA/public key operations for secure message delivery",
        "Isolated failures don't compromise entire system security"
      ],
      notes: "The same process isolation that helps with concurrency also enhances security. By keeping encryption contexts in separate processes, you get natural boundaries between users and their security material."
    },

    %{
      id: 46,
      title: "Using Libraries Safely",
      content: "Best practices for crypto in Elixir applications.",
      bullets: [
        "Never roll your own crypto algorithms",
        "Use established libraries like Ockam or Noise Protocol",
        "Phoenix provides tools like Phoenix.Token for simple needs",
        "BEAM handles computational load of encryption efficiently"
      ],
      notes: "As with any platform, the cardinal rule of cryptography applies: don't create your own crypto algorithms. Use established libraries and protocols. The difference with BEAM is that integrating these into your concurrent application is straightforward due to the process model."
    },

    %{
      id: 47,
      title: "Crash Recovery in a Chat App",
      content: "Building resilient messaging services",
      style: "title-slide",
      notes: "Let's look at how BEAM's fault tolerance capabilities apply specifically to a chat application where uptime and reliability are critical."
    },

    %{
      id: 48,
      title: "Uptime Requirements for Chat",
      content: "Messaging apps have high expectations for availability.",
      bullets: [
        "Users notice even brief outages immediately",
        "Failed message delivery creates frustration",
        "Service must recover quickly from issues",
        "BEAM's fault tolerance is a perfect match"
      ],
      notes: "Chat applications have particularly tough requirements for uptime. Unlike a website where a brief glitch might be tolerable, a chat service that drops messages or connections is immediately noticeable and frustrating to users."
    },

    %{
      id: 49,
      title: "Supervision for Chat Components",
      content: "Organizing your app for automatic recovery.",
      bullets: [
        "Supervisor for all room processes",
        "Supervisor for user connection processes",
        "Each component runs under appropriate supervision",
        "Failures in one room don't affect others"
      ],
      notes: "By structuring your chat app with proper supervision, individual failures remain isolated. If one chat room has an issue, only users in that room are affected, and even then only briefly as the supervisor restarts the process."
    },

    %{
      id: 50,
      title: "Isolating Errors in Chat",
      content: "Containing failures to minimize user impact.",
      bullets: [
        "User-specific bugs only affect that user's connection",
        "Room-specific issues contained to just that room",
        "Rest of the system continues operating normally",
        "Users can reconnect to recovered processes"
      ],
      notes: "The compartmentalization of failures means no global outages from local bugs. This is particularly valuable in a chat system where different users might be using different features or sending different kinds of content that could trigger edge case bugs."
    },

    %{
      id: 51,
      title: "State Recovery Strategies",
      content: "Ensuring chat continuity after process restarts.",
      bullets: [
        "Room processes can reload recent messages from database",
        "User processes can reconnect and restore session state",
        "OTP provides hooks for initialization after restart",
        "Design for recovery from the beginning"
      ],
      notes: "Because we know processes might restart, we design with recovery in mind. For example, when a chat room process restarts, it can load recent messages from persistent storage so the conversation history isn't lost. The key is planning for resilience from the start."
    },

    %{
      id: 52,
      title: "Supervision Strategies for Chat",
      content: "Choosing the right restart approach for each component.",
      bullets: [
        "one_for_one: for independent user connections",
        "one_for_all: for interdependent components",
        "rest_for_one: for sequential dependencies",
        "Containment scopes for different failure types"
      ],
      notes: "The different supervision strategies let you define the scope of recovery precisely. Most components in a chat app are independent, so one_for_one is common, but you might use other strategies where appropriate."
    },

    %{
      id: 53,
      title: "Real Recovery Scenarios",
      content: "How BEAM handles typical chat app failures.",
      bullets: [
        "Translation API outage only affects translation feature",
        "Bug in one user's message handling doesn't crash other users",
        "Process per connection means isolated failure domains",
        "System auto-recovers without developer intervention"
      ],
      notes: "Even at 3 AM, if some processes crash, the BEAM will restart them automatically according to the supervision strategies. You'll fix the underlying bug later, but in the meantime, the system keeps running with minimal disruption."
    },

    %{
      id: 54,
      title: "Deploying & Hosting Elixir",
      content: "Running your BEAM app in production",
      style: "title-slide",
      notes: "Now let's look at how to deploy and host Elixir applications, with a focus on modern cloud platforms that work well with BEAM's distributed nature."
    },

    %{
      id: 55,
      title: "Deployment Options",
      content: "Where to host your Elixir messaging application.",
      bullets: [
        "Containerization with Docker",
        "Traditional VMs or bare metal servers",
        "Platform-as-a-Service options",
        "Global distribution for low-latency chat"
      ],
      notes: "BEAM applications can be deployed in various ways, from traditional servers to modern containerized environments. The right choice depends on your specific needs and scale."
    },

    %{
      id: 56,
      title: "Fly.io for Elixir",
      content: "A popular platform for BEAM applications.",
      bullets: [
        "Deploy globally distributed applications",
        "Automatic WireGuard mesh networking",
        "Easy clustering of BEAM nodes",
        "Simple deployment through flyctl CLI"
      ],
      notes: "Fly.io has become particularly popular in the Elixir community because it makes it easy to run applications in a distributed manner across the globe, which aligns well with BEAM's distributed capabilities."
    },

    %{
      id: 57,
      title: "BEAM Clustering",
      content: "Connecting nodes for a distributed application.",
      bullets: [
        "Built-in distribution protocol in BEAM",
        "Processes can communicate across nodes seamlessly",
        "Libraries like libcluster automate cluster formation",
        "Phoenix PubSub works across distributed nodes"
      ],
      notes: "This is where BEAM really shines. The VM was built with distribution in mind, so connecting nodes and letting processes communicate across them is built into the platform, not an afterthought."
    },

    %{
      id: 58,
      title: "Deployment Workflow",
      content: "From development to production with Elixir.",
      bullets: [
        "Package app with mix release",
        "Deploy to single region initially",
        "Add regions as user base grows",
        "Automatic node discovery and connection"
      ],
      code: "fly launch    # Detect Elixir app and setup deployment\nfly scale count 3 --region fra,syd,sjc    # Scale globally",
      notes: "Starting with a single region and then expanding is straightforward with BEAM applications. The clustering capabilities mean your application can grow organically without major architectural changes."
    },

    %{
      id: 59,
      title: "Hosting Considerations",
      content: "Factors that affect your deployment choices.",
      bullets: [
        "Resource requirements (BEAM is efficient)",
        "Geographic distribution for low latency",
        "Clustering vs. separate nodes approach",
        "Monitoring and observability needs"
      ],
      notes: "BEAM applications are generally resource-efficient. A small VM with 1-2 CPUs and 1-2 GB RAM can handle moderate loads. This efficiency means you can run more instances or save on hosting costs."
    },

    %{
      id: 60,
      title: "Hot Upgrades & Uptime",
      content: "Approaches to zero-downtime deployments.",
      bullets: [
        "OTP supports hot code upgrades without restarts",
        "Rolling deployments across cluster nodes",
        "Blue-green deployment strategies",
        "Maintain uptime even during updates"
      ],
      notes: "For demanding applications, BEAM's capability to upgrade code without stopping the system can be invaluable. More commonly, though, rolling deployments across a cluster achieve similar results with less complexity."
    },

    %{
      id: 61,
      title: "Monitoring in Production",
      content: "Keeping your messaging app healthy.",
      bullets: [
        "LiveDashboard for real-time BEAM metrics",
        "APM tools like AppSignal or New Relic",
        "Logging and alerting for crashes",
        "Visibility into process counts and memory usage"
      ],
      notes: "The BEAM VM provides excellent introspection tools. Phoenix's LiveDashboard gives you a window into the running system, showing metrics like process counts, memory usage, and more."
    },

    %{
      id: 62,
      title: "Conclusion",
      content: "Why BEAM and Elixir excel for messaging apps",
      style: "title-slide",
      notes: "Let's summarize what we've learned about using BEAM and Elixir for building modern messaging applications."
    },

    %{
      id: 63,
      title: "Key Takeaways",
      content: "The unique advantages of the BEAM platform.",
      bullets: [
        "Concurrency: Millions of processes handling work in parallel",
        "Fault Tolerance: Supervision and automatic recovery",
        "Soft Real-Time: Responsive even under heavy load",
        "Distribution: Seamless scaling across multiple nodes"
      ],
      notes: "These are the foundational strengths that make BEAM particularly well-suited for applications like chat systems that need to handle many concurrent users with high reliability."
    },

    %{
      id: 64,
      title: "Real-World Benefits",
      content: "How these strengths translate to your app.",
      bullets: [
        "Handle countless connections simultaneously",
        "Integrate external services without blocking",
        "Recover automatically from partial failures",
        "Scale horizontally with minimal effort"
      ],
      notes: "The theoretical advantages translate directly to practical benefits for your messaging application. Features that would be challenging to implement reliably in other platforms become straightforward with BEAM."
    },

    %{
      id: 65,
      title: "Getting Started",
      content: "Next steps for exploring Elixir and Phoenix.",
      bullets: [
        "Try Elixir: Interactive learning at elixir-lang.org",
        "Explore Phoenix: Build a real-time app with Channels or LiveView",
        "Join the community: Elixir Forum, Discord, Slack",
        "Experiment with spawning processes and message passing"
      ],
      notes: "The Elixir community is welcoming to newcomers, with excellent documentation and learning resources. Starting with a small experiment in concurrency can be a fun way to see BEAM's power firsthand."
    },

    %{
      id: 66,
      title: "Questions?",
      content: "Thank you for your attention!",
      bullets: [
        "What aspects of BEAM or Elixir interest you most?",
        "Which features would you like to explore further?",
        "Have you worked with other concurrent systems?",
        "How might these concepts apply to your projects?"
      ],
      notes: "This is a good time to open up for questions and discussion. People often want to know more about specific aspects of concurrency, how BEAM compares to other systems they're familiar with, or practical advice for getting started."
    }
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_slide: 1, slides: @slides, presenter_mode: false)}
  end

  def handle_event("next_slide", _params, socket) do
    current = socket.assigns.current_slide
    max_slide = length(@slides)

    next_slide = if current < max_slide, do: current + 1, else: current
    {:noreply, assign(socket, current_slide: next_slide)}
  end

  def handle_event("prev_slide", _params, socket) do
    current = socket.assigns.current_slide

    prev_slide = if current > 1, do: current - 1, else: current
    {:noreply, assign(socket, current_slide: prev_slide)}
  end

  # Add keyboard navigation
  def handle_event("keydown", %{"key" => "ArrowRight"}, socket) do
    handle_event("next_slide", %{}, socket)
  end

  def handle_event("keydown", %{"key" => "ArrowLeft"}, socket) do
    handle_event("prev_slide", %{}, socket)
  end

  # Toggle presenter mode with 'p' key
  def handle_event("keydown", %{"key" => "p"}, socket) do
    {:noreply, assign(socket, presenter_mode: !socket.assigns.presenter_mode)}
  end

  def handle_event("keydown", _key, socket) do
    {:noreply, socket}
  end

  # Toggle presenter mode with button
  def handle_event("toggle_presenter_mode", _params, socket) do
    {:noreply, assign(socket, presenter_mode: !socket.assigns.presenter_mode)}
  end

  def render(assigns) do
    ~H"""
    <div class="slide-container" phx-window-keydown="keydown">
        <div class={"slide #{Map.get(Enum.find(@slides, fn s -> s.id == @current_slide end), :style, "")}"}>
            <% current_slide = Enum.find(@slides, fn s -> s.id == @current_slide end) %>
            <h1><%= current_slide.title %></h1>
            <div class="content">
                <p><%= current_slide.content %></p>

                <%= if Map.has_key?(current_slide, :bullets) do %>
                  <ul>
                    <%= for bullet <- current_slide.bullets do %>
                      <li><%= bullet %></li>
                    <% end %>
                  </ul>
                <% end %>

                <%= if Map.has_key?(current_slide, :image) do %>
                  <img src={current_slide.image} alt="Slide image" />
                <% end %>

                <%= if Map.has_key?(current_slide, :code) do %>
                  <div class="code-block">
                    <pre><code><%= current_slide.code %></code></pre>
                  </div>
                <% end %>
            </div>
        </div>

        <%= if @presenter_mode and Map.has_key?(current_slide, :notes) do %>
          <div class="speaker-notes">
            <h3>Speaker Notes:</h3>
            <p><%= current_slide.notes %></p>
          </div>
        <% end %>

        <div class="controls">
            <button phx-click="prev_slide">Previous</button>
            <span class="slide-number"><%= @current_slide %>/<%= length(@slides) %></span>
            <button phx-click="next_slide">Next</button>
            <button phx-click="toggle_presenter_mode" class={"presenter-toggle #{if @presenter_mode, do: "active"}"}>
              <%= if @presenter_mode, do: "Hide Notes", else: "Show Notes" %>
            </button>
        </div>
    </div>
    """
  end
end
