using System;

public class Option<T>
{
    private readonly T _value;
    public bool IsSome { get; }
    public bool IsNone => !IsSome;

    private Option(T value, bool isSome)
    {
        _value = value;
        IsSome = isSome;
    }

    public static Option<T> Some(T value) => new Option<T>(value, true);
    public static Option<T> None() => new Option<T>(default, false);

    public T UnwrapOr(T defaultValue) => IsSome ? _value : defaultValue;
    public T UnwrapOrThrow(string errorMessage)
    {
        if (IsSome) return _value;
        throw new InvalidOperationException(errorMessage);
    }
}


class Program
{
    static Option<double> SafeDivide(double x, double y)
    {
        if (y == 0)
            return Option<double>.None(); // Return None when division by zero
        return Option<double>.Some(x / y);
    }

    static void Main()
    {
        var result1 = SafeDivide(10, 2); // Valid division
        var result2 = SafeDivide(result1.UnwrapOr(0), 0); // Invalid division, returns None

        if (result2.IsSome)
        {
            Console.WriteLine($"Result: {result2.UnwrapOr(0)}");
        }
        else
        {
            Console.WriteLine("Error: Cannot divide by zero");
        }
    }
}
// Output: Error: Cannot divide by zero
