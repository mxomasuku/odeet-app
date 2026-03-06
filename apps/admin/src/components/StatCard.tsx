import type { LucideIcon } from "lucide-react";

interface StatCardProps {
  label: string;
  value: string | number;
  icon: LucideIcon;
  color?: "blue" | "green" | "purple" | "orange" | "red" | "gray";
  loading?: boolean;
}

const colorClasses = {
  blue: {
    bg: "bg-blue-50",
    icon: "text-blue-600",
    border: "border-blue-100",
  },
  green: {
    bg: "bg-emerald-50",
    icon: "text-emerald-600",
    border: "border-emerald-100",
  },
  purple: {
    bg: "bg-purple-50",
    icon: "text-purple-600",
    border: "border-purple-100",
  },
  orange: {
    bg: "bg-orange-50",
    icon: "text-orange-600",
    border: "border-orange-100",
  },
  red: {
    bg: "bg-red-50",
    icon: "text-red-600",
    border: "border-red-100",
  },
  gray: {
    bg: "bg-gray-50",
    icon: "text-gray-600",
    border: "border-gray-100",
  },
};

export function StatCard({
  label,
  value,
  icon: Icon,
  color = "blue",
  loading = false,
}: StatCardProps) {
  const colors = colorClasses[color];

  return (
    <div
      className={`rounded-xl border bg-white p-6 shadow-sm transition-shadow hover:shadow-md ${colors.border}`}
    >
      <div className="flex items-start justify-between">
        <div className="flex-1">
          <p className="text-sm font-medium text-gray-500">{label}</p>
          {loading ? (
            <div className="skeleton mt-2 h-8 w-20" />
          ) : (
            <p className="mt-2 text-3xl font-bold text-gray-900">{value}</p>
          )}
        </div>
        <div className={`rounded-lg p-3 ${colors.bg}`}>
          <Icon className={`h-6 w-6 ${colors.icon}`} />
        </div>
      </div>
    </div>
  );
}
