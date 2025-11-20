import React from 'react';

const Cell = ({ children, className = '', type = 'default', rowSpan = 1 }) => {
    // Increased height (py-6) and compressed width (px-0.5, text-[8px])
    const baseClasses = "flex items-center justify-center px-0.5 py-6 text-center border border-gray-300 text-[8px] leading-none h-full break-words overflow-hidden";

    const typeClasses = {
        default: "bg-white text-black font-normal",
        idle: "bg-gray-50 text-gray-400 font-light italic",
        header: "bg-gray-100 font-bold uppercase tracking-wider text-black text-[7px] py-3", // Smaller header, less height
        time: "bg-white font-mono text-[7px] font-normal text-black align-middle rotate-0", // Tiny time
        break: "bg-gray-200 text-black font-bold tracking-widest uppercase text-[7px]",
    };

    // Calculate row span style
    const style = rowSpan > 1 ? { gridRow: `span ${rowSpan} / span ${rowSpan}` } : {};

    return (
        <div
            className={`${baseClasses} ${typeClasses[type] || typeClasses.default} ${className}`}
            style={style}
        >
            {children}
        </div>
    );
};

const ScheduleTable = () => {
    return (
        <div className="w-full overflow-x-auto border border-gray-300 shadow-sm">
            {/* Increased Time col width from 25px to 40px */}
            <div className="grid grid-cols-[40px_repeat(5,1fr)] bg-gray-300 min-w-[280px] gap-[1px] border border-gray-300">

                {/* --- Header Row --- */}
                <Cell type="header">Time</Cell>
                <Cell type="header">Mon</Cell>
                <Cell type="header">Tue</Cell>
                <Cell type="header">Wed</Cell>
                <Cell type="header">Thu</Cell>
                <Cell type="header">Fri</Cell>

                {/* --- 9 AM Row --- */}
                <Cell type="time">9:00</Cell>
                <Cell />
                <Cell />
                <Cell />
                <Cell />
                <Cell />

                {/* --- 10 AM Row --- */}
                <Cell type="time">10:00</Cell>
                <Cell />
                <Cell />
                <Cell />
                <Cell />
                <Cell />

                {/* --- 11 AM Row --- */}
                <Cell type="time">11:00</Cell>
                <Cell />
                <Cell />
                <Cell />
                <Cell />
                <Cell />

                {/* --- 12 PM Row --- */}
                <Cell type="time">12:00</Cell>
                <Cell />
                <Cell />
                <Cell />
                <Cell />
                <Cell />

                {/* --- 1 PM Lunch (Merged) --- */}
                <Cell type="time">1:00</Cell>
                <Cell type="break" className="col-span-5">Lunch</Cell>

                {/* --- 2 PM Row --- */}
                <Cell type="time">2:00</Cell>
                <Cell />
                <Cell />
                <Cell />
                <Cell />
                <Cell />

                {/* --- 3 PM Row --- */}
                <Cell type="time">3:00</Cell>
                <Cell />
                <Cell />
                <Cell />
                <Cell />
                <Cell />

                {/* --- 4 PM Row --- */}
                <Cell type="time">4:00</Cell>
                <Cell />
                <Cell />
                <Cell />
                <Cell />
                <Cell />

                {/* --- 5 PM Row --- */}
                <Cell type="time">5:00</Cell>
                <Cell />
                <Cell />
                <Cell />
                <Cell />
                <Cell />

            </div>
        </div>
    );
};

export default function App() {
    return (
        <div className="min-h-screen bg-white text-gray-900 font-sans flex flex-col">

            {/* Header */}
            <header className="bg-white border-b border-gray-300 px-2 p-1">
                <div className="max-w-sm mx-auto">
                    <h1 className="text-lg font-bold text-black leading-tight">Week Schedule</h1>
                    <p className="text-gray-500 text-[10px]">Spring / 3rd / DSAI / 2025</p>
                </div>
            </header>

            {/* Content */}
            <main className="flex-1 max-w-sm w-full mx-auto p-1 overflow-hidden flex flex-col">
                <ScheduleTable />
            </main>
        </div>
    );
}