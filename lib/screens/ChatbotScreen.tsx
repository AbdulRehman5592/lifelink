import { useState, useRef, useEffect } from "react";
import { Bot, Send, User, Sparkles } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { cn } from "@/lib/utils";

interface Message {
  id: string;
  role: "user" | "assistant";
  content: string;
  timestamp: Date;
}

const suggestedQuestions = [
  "How can I donate blood?",
  "Find nearby medicine banks",
  "Organ donation eligibility",
  "Check my donation history",
];

export const ChatbotScreen = () => {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: "welcome",
      role: "assistant",
      content:
        "Hello! 👋 I'm your LifeLink AI assistant. I can help you with blood donation, medicine sharing, organ registry, and more. How can I assist you today?",
      timestamp: new Date(),
    },
  ]);
  const [input, setInput] = useState("");
  const [isTyping, setIsTyping] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  const handleSend = (text?: string) => {
    const messageText = text || input.trim();
    if (!messageText) return;

    const userMessage: Message = {
      id: Date.now().toString(),
      role: "user",
      content: messageText,
      timestamp: new Date(),
    };

    setMessages((prev) => [...prev, userMessage]);
    setInput("");
    setIsTyping(true);

    // Simulate AI response (replace with real backend later)
    setTimeout(() => {
      const botMessage: Message = {
        id: (Date.now() + 1).toString(),
        role: "assistant",
        content: getSimulatedResponse(messageText),
        timestamp: new Date(),
      };
      setMessages((prev) => [...prev, botMessage]);
      setIsTyping(false);
    }, 1200);
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  };

  return (
    <div className="flex flex-col h-[calc(100vh-8rem)]">
      {/* Header */}
      <div className="px-4 py-5 gradient-primary">
        <div className="flex items-center gap-3 text-primary-foreground">
          <div className="w-12 h-12 rounded-xl bg-primary-foreground/20 flex items-center justify-center">
            <Bot size={28} />
          </div>
          <div>
            <h1 className="font-roboto text-2xl font-bold">AI Assistant</h1>
            <p className="text-sm opacity-80 flex items-center gap-1">
              <span className="w-2 h-2 rounded-full bg-success inline-block" />
              Online — Ready to help
            </p>
          </div>
        </div>
      </div>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto px-4 py-4 space-y-4">
        {messages.map((message) => (
          <div
            key={message.id}
            className={cn(
              "flex gap-2 animate-fade-in",
              message.role === "user" ? "justify-end" : "justify-start"
            )}
          >
            {message.role === "assistant" && (
              <div className="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center shrink-0 mt-1">
                <Sparkles size={16} className="text-primary" />
              </div>
            )}
            <div
              className={cn(
                "max-w-[80%] rounded-2xl px-4 py-3 text-sm leading-relaxed",
                message.role === "user"
                  ? "bg-primary text-primary-foreground rounded-br-md"
                  : "bg-card border border-border text-foreground rounded-bl-md shadow-sm"
              )}
            >
              {message.content}
            </div>
            {message.role === "user" && (
              <div className="w-8 h-8 rounded-full bg-primary flex items-center justify-center shrink-0 mt-1">
                <User size={16} className="text-primary-foreground" />
              </div>
            )}
          </div>
        ))}

        {isTyping && (
          <div className="flex gap-2 items-start animate-fade-in">
            <div className="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
              <Sparkles size={16} className="text-primary" />
            </div>
            <div className="bg-card border border-border rounded-2xl rounded-bl-md px-4 py-3 shadow-sm">
              <div className="flex gap-1">
                <span className="w-2 h-2 rounded-full bg-muted-foreground/40 animate-bounce" style={{ animationDelay: "0ms" }} />
                <span className="w-2 h-2 rounded-full bg-muted-foreground/40 animate-bounce" style={{ animationDelay: "150ms" }} />
                <span className="w-2 h-2 rounded-full bg-muted-foreground/40 animate-bounce" style={{ animationDelay: "300ms" }} />
              </div>
            </div>
          </div>
        )}
        <div ref={messagesEndRef} />
      </div>

      {/* Suggested questions (show only when few messages) */}
      {messages.length <= 1 && (
        <div className="px-4 pb-2">
          <p className="text-xs text-muted-foreground mb-2 font-medium">Suggested questions</p>
          <div className="flex flex-wrap gap-2">
            {suggestedQuestions.map((q) => (
              <button
                key={q}
                onClick={() => handleSend(q)}
                className="text-xs bg-primary/5 text-primary border border-primary/20 rounded-full px-3 py-1.5 hover:bg-primary/10 transition-colors"
              >
                {q}
              </button>
            ))}
          </div>
        </div>
      )}

      {/* Input */}
      <div className="px-4 py-3 border-t border-border bg-card">
        <div className="flex gap-2">
          <Input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={handleKeyDown}
            placeholder="Ask me anything..."
            className="flex-1 rounded-xl"
            disabled={isTyping}
          />
          <Button
            size="icon"
            onClick={() => handleSend()}
            disabled={!input.trim() || isTyping}
            className="rounded-xl shrink-0"
          >
            <Send size={18} />
          </Button>
        </div>
      </div>
    </div>
  );
};

function getSimulatedResponse(question: string): string {
  const q = question.toLowerCase();
  if (q.includes("blood") || q.includes("donate"))
    return "To donate blood, you need to be at least 17 years old and weigh over 50 kg. You can visit the Blood section in the app to find nearby donation centers or respond to urgent requests. Would you like me to guide you through the process?";
  if (q.includes("medicine"))
    return "You can share unused, unexpired medicines through our Medicine section. Simply list the medicine with its expiry date and location, and those in need can request it. All medicines go through a verification process.";
  if (q.includes("organ"))
    return "Organ donation registration is a noble decision. You can register as an organ donor through our Organ section. The process involves filling out a consent form and getting verified. Would you like to know more about eligibility?";
  if (q.includes("history") || q.includes("donation"))
    return "You can check your complete donation history in your Profile section. It shows all your blood donations, medicine shares, and any organ registry status. Would you like me to take you there?";
  return "That's a great question! I'm here to help with anything related to blood donation, medicine sharing, organ donation, and medical emergencies in Pakistan. Could you provide more details so I can assist you better?";
}
