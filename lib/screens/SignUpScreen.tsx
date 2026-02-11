import { useState } from "react";
import { Mail, Lock, Eye, EyeOff, ArrowRight, User, Phone } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { LifeLinkLogoIcon } from "@/components/icons/MedicalIcons";
import { useToast } from "@/hooks/use-toast";

interface SignUpScreenProps {
  onNavigate: (screen: string) => void;
}

export const SignUpScreen = ({ onNavigate }: SignUpScreenProps) => {
  const [showPassword, setShowPassword] = useState(false);
  const [form, setForm] = useState({
    fullName: "",
    email: "",
    phone: "",
    password: "",
    confirmPassword: "",
  });
  const { toast } = useToast();

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  };

  const handleSignUp = () => {
    if (!form.fullName || !form.email || !form.password || !form.confirmPassword) {
      toast({
        title: "Missing Information",
        description: "Please fill in all required fields.",
        variant: "destructive",
      });
      return;
    }
    if (form.password !== form.confirmPassword) {
      toast({
        title: "Password Mismatch",
        description: "Passwords do not match.",
        variant: "destructive",
      });
      return;
    }
    toast({ title: "Account Created!", description: "Welcome to LifeLink Pakistan." });
    onNavigate("home");
  };

  return (
    <div className="min-h-screen flex flex-col justify-center px-6 py-10 bg-background">
      {/* Logo */}
      <div className="flex flex-col items-center mb-8 animate-fade-in">
        <div className="text-primary mb-3">
          <LifeLinkLogoIcon size={48} />
        </div>
        <h1 className="font-roboto text-2xl font-bold text-foreground">
          Create Account
        </h1>
        <p className="text-muted-foreground text-sm mt-2 text-center">
          Join LifeLink and start saving lives
        </p>
      </div>

      {/* Form */}
      <div className="space-y-4 max-w-sm mx-auto w-full animate-fade-in" style={{ animationDelay: "100ms" }}>
        <div className="space-y-2">
          <Label htmlFor="fullName">Full Name *</Label>
          <div className="relative">
            <User size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
            <Input
              id="fullName"
              name="fullName"
              placeholder="Enter your full name"
              className="pl-10"
              value={form.fullName}
              onChange={handleChange}
            />
          </div>
        </div>

        <div className="space-y-2">
          <Label htmlFor="email">Email *</Label>
          <div className="relative">
            <Mail size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
            <Input
              id="email"
              name="email"
              type="email"
              placeholder="you@example.com"
              className="pl-10"
              value={form.email}
              onChange={handleChange}
            />
          </div>
        </div>

        <div className="space-y-2">
          <Label htmlFor="phone">Phone Number</Label>
          <div className="relative">
            <Phone size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
            <Input
              id="phone"
              name="phone"
              type="tel"
              placeholder="+92 300 1234567"
              className="pl-10"
              value={form.phone}
              onChange={handleChange}
            />
          </div>
        </div>

        <div className="space-y-2">
          <Label htmlFor="password">Password *</Label>
          <div className="relative">
            <Lock size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
            <Input
              id="password"
              name="password"
              type={showPassword ? "text" : "password"}
              placeholder="••••••••"
              className="pl-10 pr-10"
              value={form.password}
              onChange={handleChange}
            />
            <button
              type="button"
              onClick={() => setShowPassword(!showPassword)}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground transition-colors"
            >
              {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
            </button>
          </div>
        </div>

        <div className="space-y-2">
          <Label htmlFor="confirmPassword">Confirm Password *</Label>
          <div className="relative">
            <Lock size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
            <Input
              id="confirmPassword"
              name="confirmPassword"
              type={showPassword ? "text" : "password"}
              placeholder="••••••••"
              className="pl-10"
              value={form.confirmPassword}
              onChange={handleChange}
            />
          </div>
        </div>

        <Button variant="hero" size="xl" className="w-full mt-2" onClick={handleSignUp}>
          Create Account
          <ArrowRight size={18} />
        </Button>

        {/* Terms */}
        <p className="text-xs text-muted-foreground text-center mt-3">
          By signing up, you agree to our{" "}
          <button className="text-primary hover:underline">Terms of Service</button>{" "}
          and{" "}
          <button className="text-primary hover:underline">Privacy Policy</button>
        </p>
      </div>

      {/* Sign in link */}
      <p className="text-center text-sm text-muted-foreground mt-8 animate-fade-in" style={{ animationDelay: "200ms" }}>
        Already have an account?{" "}
        <button onClick={() => onNavigate("signin")} className="text-primary font-semibold hover:underline">
          Sign In
        </button>
      </p>
    </div>
  );
};
